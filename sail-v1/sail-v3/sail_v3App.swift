//
//  sail_v1App.swift
//  sail-v1
//
//  Created by Alice Mao on 12/7/23.
//

import SwiftUI

struct AppView: View {
    let persistenceController = PersistenceController.shared

    var body: some View {
//        BluetoothView()
        
        ContentView()
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
}

@main
struct sail_v3App: App {
    @StateObject var currTest = Test()
    
    var body: some Scene {
        WindowGroup {
            OnboardView().environmentObject(currTest)
        }
    }
}
