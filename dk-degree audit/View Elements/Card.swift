//
//  Card.swift
//  dk-degree audit
//
//  Created by Dustin Knopoff on 11/28/20.
//

import Foundation
import SwiftUI

struct BaseCard<Content: View>: View {
	var content: () -> Content
	
	init(@ViewBuilder _ content: @escaping () -> Content) {
		self.content = content
	}
	
	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 20)
				.shadow(radius: 4, x: 0, y: 4)
				.foregroundColor(.newPrimaryColor)
			content()
		}
		
		.frame(minHeight: 100)
	}
}

struct BaseCard_Previews: PreviewProvider {
	static var previews: some View {
		BaseCard {
			Text("Hello")
		}
	}
}

struct MinimalCard<Content: View>: View {
	var content: () -> Content
	
	init(@ViewBuilder _ content: @escaping () -> Content) {
		self.content = content
	}
	
	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 20)
				.shadow(radius: 4, x: 0, y: 4)
				.foregroundColor(.newPrimaryColor)
			content()
		}
		.frame(maxHeight: 100)
	}
}

struct MinimalCard_Previews: PreviewProvider {
	static var previews: some View {
		BaseCard {
			Text("Hello")
		}
	}
}
