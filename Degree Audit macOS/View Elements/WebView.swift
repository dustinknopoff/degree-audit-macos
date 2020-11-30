import SwiftUI
import WebKit

struct Webview_Preview: PreviewProvider {
	static var previews: some View {
		NavigationView {
			WebView(url: URL.init(string: "https://www.google.com")!, webViewStateModel: WebViewStateModel())
				.frame(width: 400)
		}
		
	}
}

class WebViewStateModel: ObservableObject {
	@Published var pageTitle: String = "Web View"
	@Published var loading: Bool = false
	@Published var canGoBack: Bool = false
	@Published var goBack: Bool = false
	@Published var pageContent = ""
}

struct WebView: View {
	enum NavigationAction {
		case decidePolicy(WKNavigationAction,  (WKNavigationActionPolicy) -> Void) //mendetory
		case didRecieveAuthChallange(URLAuthenticationChallenge, (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) //mendetory
		case didStartProvisionalNavigation(WKNavigation)
		case didReceiveServerRedirectForProvisionalNavigation(WKNavigation)
		case didCommit(WKNavigation)
		case didFinish(WKNavigation)
		case didFailProvisionalNavigation(WKNavigation,Error)
		case didFail(WKNavigation,Error)
	}
	
	@ObservedObject var webViewStateModel: WebViewStateModel
	
	private var actionDelegate: ((_ navigationAction: WebView.NavigationAction) -> Void)?
	
	
	let uRLRequest: URLRequest
	
	
	var body: some View {
		
		WebViewWrapper(webViewStateModel: webViewStateModel,
					   action: actionDelegate,
					   request: uRLRequest)
	}
	/*
	if passed onNavigationAction it is mendetory to complete URLAuthenticationChallenge and decidePolicyFor callbacks
	*/
	init(uRLRequest: URLRequest, webViewStateModel: WebViewStateModel, onNavigationAction: ((_ navigationAction: WebView.NavigationAction) -> Void)?) {
		self.uRLRequest = uRLRequest
		self.webViewStateModel = webViewStateModel
		self.actionDelegate = onNavigationAction
	}
	
	init(url: URL, webViewStateModel: WebViewStateModel, onNavigationAction: ((_ navigationAction: WebView.NavigationAction) -> Void)? = nil) {
		self.init(uRLRequest: URLRequest(url: url),
				  webViewStateModel: webViewStateModel,
				  onNavigationAction: onNavigationAction)
	}
}

/*
A weird case: if you change WebViewWrapper to struct cahnge in WebViewStateModel will never call updateUIView
*/

final class WebViewWrapper : NSViewRepresentable {
	@ObservedObject var webViewStateModel: WebViewStateModel
	let action: ((_ navigationAction: WebView.NavigationAction) -> Void)?
	
	let request: URLRequest
	
	init(webViewStateModel: WebViewStateModel,
		 action: ((_ navigationAction: WebView.NavigationAction) -> Void)?,
		 request: URLRequest) {
		self.action = action
		self.request = request
		self.webViewStateModel = webViewStateModel
	}
	
	
	func makeNSView(context: Context) -> WKWebView  {
		let view = WKWebView()
		view.navigationDelegate = context.coordinator
		view.load(request)
		return view
	}
	
	func updateNSView(_ uiView: WKWebView, context: Context) {
		if uiView.canGoBack, webViewStateModel.goBack {
			uiView.goBack()
			webViewStateModel.goBack = true
		}
	}
	
	
	
	func makeCoordinator() -> Coordinator {
		return Coordinator(action: action, webViewStateModel: webViewStateModel)
	}
	
	final class Coordinator: NSObject {
		@ObservedObject var webViewStateModel: WebViewStateModel
		let action: ((_ navigationAction: WebView.NavigationAction) -> Void)?
		
		init(action: ((_ navigationAction: WebView.NavigationAction) -> Void)?,
			 webViewStateModel: WebViewStateModel) {
			self.action = action
			self.webViewStateModel = webViewStateModel
			
		}
		
	}
}

extension WebViewWrapper.Coordinator: WKNavigationDelegate {
	
	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		
		if action == nil {
			decisionHandler(.allow)
		} else {
			action?(.decidePolicy(navigationAction, decisionHandler))
		}
	}
	
	func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
		webViewStateModel.loading = true
		action?(.didStartProvisionalNavigation(navigation))
	}
	
	func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
		action?(.didReceiveServerRedirectForProvisionalNavigation(navigation))
		
	}
	
	func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
		webViewStateModel.loading = false
		webViewStateModel.canGoBack = webView.canGoBack
		action?(.didFailProvisionalNavigation(navigation, error))
	}
	
	func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
		action?(.didCommit(navigation))
	}
	
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		webViewStateModel.loading = false
		webViewStateModel.canGoBack = webView.canGoBack
		if let title = webView.title {
			webViewStateModel.pageTitle = title
		}
		webView.evaluateJavaScript("""
                  var docu = document.documentElement.innerHTML;
               docu
               """) { (result,error) in
			// Do some error checking
			if (error != nil || result == nil) {
				return
			}
			
			// If the Javascript function returns an object, cast it into a Dictionary
			let content = result as! String
			self.webViewStateModel.pageContent = content
		}
		action?(.didFinish(navigation))
	}
	
	func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
		webViewStateModel.loading = false
		webViewStateModel.canGoBack = webView.canGoBack
		action?(.didFail(navigation, error))
	}
	
	func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
		
		if action == nil  {
			completionHandler(.performDefaultHandling, nil)
		} else {
			action?(.didRecieveAuthChallange(challenge, completionHandler))
		}
		
	}
	
}

extension WebViewWrapper.Coordinator: WKUIDelegate {
	func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
		if navigationAction.targetFrame == nil {
			webView.load(navigationAction.request)
		}
		
		return nil
	}
}
