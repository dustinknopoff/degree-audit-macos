//
//  Top.swift
//  dk-degree audit
//
//  Created by Dustin Knopoff on 11/28/20.
//

import SwiftUI

struct Top: View {
	@State var showAlert = false
	@ObservedObject var webviewmodel = WebViewStateModel()
	
    var body: some View {
		VStack(alignment: .leading) {
			H1(text: "Northeastern University")
				.foregroundColor(.red)
			H1(text:"Computer Science and Design Degree Audit")
		}.onTapGesture {
			showAlert.toggle()
		}
		.popover(isPresented: $showAlert) {
			VStack {
				HStack {
					Spacer()
					Button("Dismiss") {
						self.showAlert.toggle()
						print(self.webviewmodel.pageTitle, self.webviewmodel.pageTitle == "Web Audit")
						if self.webviewmodel.pageTitle == "Web Audit" {
							try! FilesManager().save(fileNamed: "audit.html", data: Data(self.webviewmodel.pageContent.utf8))
							
						}
					}
				}.padding()
				WebView(url: URL(string: "https://prod-web.neu.edu/wasapp/DARSStudent/RequestAuditServlet")!, webViewStateModel: webviewmodel)
					.padding()
			}
				.frame(width: 600, height: 800)
		}
    }
}

struct Top_Previews: PreviewProvider {
    static var previews: some View {
        Top()
    }
}
