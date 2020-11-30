//
//  NameAndValue.swift
//  dk-degree audit
//
//  Created by Dustin Knopoff on 11/29/20.
//

import SwiftUI

struct NameAndValue: View {
	var name: String
	var value: String
	
    var body: some View {
		HStack {
			Text("\(name):")
				.font(Font.system(.body).smallCaps())
				.bold()
			Spacer()
			Text(value)
				.fontWeight(.light)
		}
    }
}

struct NameAndValue_Previews: PreviewProvider {
    static var previews: some View {
		NameAndValue(name: "Semester", value: "Spring 2020")
    }
}
