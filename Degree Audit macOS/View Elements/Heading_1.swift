//
//  Heading_1.swift
//  dk-degree audit
//
//  Created by Dustin Knopoff on 11/28/20.
//

import Foundation

import SwiftUI

struct H1: View {
	var text: String
	
	var body: some View {
		Text(text)
			.font(.title)
			.padding()
	}
}

struct H1_Previews: PreviewProvider {
	static var previews: some View {
		H1(text: "Northeastern University")
	}
}
