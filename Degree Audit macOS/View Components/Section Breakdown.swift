//
//  Section Breakdown.swift
//  Degree Audit macOS
//
//  Created by Dustin Knopoff on 11/29/20.
//

import SwiftUI

struct Section_Breakdown: View {
	var sections: [Section]
	@Binding var selected: String
	
    var body: some View {
		VStack {
			ForEach(sections, id: \.self) { section in
				if section.name == selected {
					ZStack {
						RoundedRectangle(cornerRadius: 20)
							.shadow(radius: 4, x: 0, y: 4)
							.foregroundColor(.newPrimaryColor)
						VStack {
							HStack {
								Text(section.name)
									.frame(maxWidth: .infinity)
								section.status.toSystemName()
							}
							
							ForEach(section.subsections, id: \.self) { sub in
								SubsectionView(sub: sub)
							}
						}
					}
					.padding()
					.animation(.linear(duration: 0.3))
					
				} else {
					MinimalCard {
						HStack {
							Text(section.name)
								.frame(maxWidth: .infinity)
							Spacer()
							section.status.toSystemName()
						}
						.padding()
						
					}
					.onTapGesture {
						self.selected = section.name
					}
					.animation(.linear(duration: 0.3))
				}
				Spacer()
				
			}
		}
		.padding()
    }
}

struct Section_Breakdown_Previews: PreviewProvider {
	
    static var previews: some View {
		Section_Breakdown(sections: Audit._default().sections, selected: Binding.constant("Computer Science Courses - Combined Major"))
			.frame(height: 800)
    }
}
