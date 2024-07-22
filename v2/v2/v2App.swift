//
//  v2App.swift
//  v2
//
//  Created by Alice Mao on 2/1/24.
//

import SwiftUI

@main
struct v2App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
