//
//  ContentView.swift
//  dk-degree audit
//
//  Created by Dustin Knopoff on 11/28/20.
//

import SwiftUI

struct ContentView: View {
	@EnvironmentObject var audit: Audit
	@State var selected = ""
	
    var body: some View {
		VStack(alignment: .leading) {
			Top()
			ScrollView() {
				LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()),GridItem(.flexible())]) {
					Summary()
				}.padding(.all, 10)
				LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
					BaseCard {
						VStack(alignment: .leading) {
							Text("Degree Requirements")
								.font(.headline).padding()
							ForEach(audit.sections, id: \.self) {section in
								HStack {
									Text(section.name)
										.foregroundColor(selected == section.name ? .red : .primary)
										.frame(maxWidth: .infinity)
									section.status.toSystemName()
								}
								.padding()
								.onTapGesture {
									selected = section.name
								}
								
							}
						}
					}
					.padding()
					VStack {
						ForEach(audit.sections, id: \.self) { section in
							if section.name == selected {
								BaseCard {
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
							} else {
								MinimalCard {
									HStack {
										Text(section.name)
											.frame(maxWidth: .infinity)
										 section.status.toSystemName()
									}
									.padding()
								}
							}
							
							
						}
					}
					.padding()
					
				}
				.padding(.all, 10)
				
			}
			
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		ContentView()
			.environmentObject(Audit._default())
			.frame(height: 600)
    }
}
