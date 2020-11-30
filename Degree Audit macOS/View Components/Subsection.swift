//
//  Subsection.swift
//  dk-degree audit
//
//  Created by Dustin Knopoff on 11/29/20.
//

import SwiftUI

struct SubsectionView: View {
	var sub: Subsection
	@State private var expanded = "Computer Science Overview"
	
    var body: some View {
		Text(sub.name)
			.foregroundColor(.gray)
			.font(Font.system(.callout).smallCaps())
			.frame(maxWidth: .infinity)
		VStack(alignment: .leading) {
			ForEach(sub.classes, id: \.self) { _class in
				if expanded == _class.name {
					HStack {
						Text(_class.name)
						Spacer()
						Image(systemName: "chevron.down")
					}
					.onTapGesture {
						expanded = ""
					}
					HStack {
						VStack {
							NameAndValue(name: "Semester", value: _class.term)
							NameAndValue(name: "Code", value: "\(_class.college) \(_class.class_no)")
						}
						VStack {
							Text(_class.grade.rawValue)
								.font(.largeTitle)
							Text("\(_class.credits, specifier: "%.2f") credits")
						}
					}
					
				} else {
					HStack(alignment: .center, spacing: 70) {
						Text(_class.name)
						Image(systemName: "chevron.up")
					}
					.onTapGesture {
						expanded = _class.name
					}
				}
			}
		}
		
    }
}

struct Subsection_Previews: PreviewProvider {

    static var previews: some View {
		SubsectionView(sub: Subsection(name: "Computer Science Overview", classes: [Class(term: "SP17", college: "CS", class_no: 1200, credits: 1.0, grade: .A, name: "CS/IS Overview 1")]))
    }
}
