//
//  Sail_v2App.swift
//  Sail-v2
//
//  Created by Alice Mao on 1/30/24.
//

import SwiftUI

@main
struct Sail_v2App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
