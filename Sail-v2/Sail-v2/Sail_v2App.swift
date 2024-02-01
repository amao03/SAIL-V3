//
//  sail_v2App.swift
//  sail-v2
//
//  Created by Alice Mao on 1/31/24.
//

import SwiftUI

@main
struct sail_v2App: App {
//    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            Phone_Landing_View()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
