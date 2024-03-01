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
struct sail_v1App: App {

    var body: some Scene {
        WindowGroup {
            AppView()
        }
    }
}


#Preview {
    AppView()
//    let persistenceController = PersistenceController.shared
//
//    
//    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
