//
//  Summary.swift
//  dk-degree audit
//
//  Created by Dustin Knopoff on 11/28/20.
//

import SwiftUI

struct Summary: View {
	@EnvironmentObject var audit: Audit
	
    var body: some View {
		BaseCard {
			VStack(alignment: .leading) {
				Text("Expected Graduation")
					.font(.headline)
				Text("\(audit.graduation.days(sinceDate: Date())!) days")
					.font(.largeTitle)
					.bold()
					.padding()
				Text("May 7, 2020")
			}.padding()
		}
		BaseCard {
			VStack(alignment: .leading) {
				Text("GPA")
					.font(.headline)
				Text("\(audit.gpa, specifier: "%.2f")")
					.font(.largeTitle)
					.bold()
					.padding()
			}.padding()
		}
		BaseCard {
			VStack(alignment: .leading) {
				Text("Catalog Year")
					.font(.headline)
				Text(audit.calendar_year)
					.font(.title3)
					.bold()
					.padding()
			}.padding()
		}
    }
}

struct Summary_Previews: PreviewProvider {
    static var previews: some View {
        Summary()
			.environmentObject(Audit._default())
    }
}
