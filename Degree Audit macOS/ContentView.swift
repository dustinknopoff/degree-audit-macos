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
				HStack {
					Summary()
				}.padding(.all, 10)
				HStack {
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
					Section_Breakdown(sections: audit.sections, selected: $selected)
					
				}
				.padding(.all, 10)
				
			}
			.padding()
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
