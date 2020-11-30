//
//  dk_degree_auditApp.swift
//  dk-degree audit
//
//  Created by Dustin Knopoff on 11/28/20.
//

import SwiftUI

@main
struct dk_degree_auditApp: App {
	@StateObject var audit: Audit = Audit._default()
	
    var body: some Scene {
        WindowGroup {
            ContentView()
				.environmentObject(audit)
        }
    }
}
