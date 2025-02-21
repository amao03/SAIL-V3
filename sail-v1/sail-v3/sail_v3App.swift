//
//  sail_v1App.swift
//  sail-v1
//
//  Created by Alice Mao on 12/7/23.
//

import SwiftUI

@main
struct sail_v3App: App {
    @StateObject var currTest = Test.test
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            OnboardView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(currTest)
                
        }
    }
}
