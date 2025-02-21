//
//  OnboardView.swift
//  sail-v3
//
//  Created by Alice Mao on 12/10/24.
//

import SwiftUI

struct OnboardView : View {
    @EnvironmentObject var currTest:Test
    @StateObject var connector = ConnectToWatch.connect
    @State var concept2monitor:PerformanceMonitor?
    
    var body : some View{
        TabView{
            BluetoothView(concept2monitor: $concept2monitor)
            SelectTestView().environmentObject(currTest)
            SelectDataTypeView().environmentObject(currTest)
            SetConfigs().environmentObject(currTest)
            SetAbovePattern().environmentObject(currTest)
            SetAtPattern().environmentObject(currTest)
            SetUnderPattern().environmentObject(currTest)
            SummaryView().environmentObject(currTest).environmentObject(connector)
            StartTestView().environmentObject(currTest).environmentObject(connector)
            SavedTestsView()
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .onAppear(perform: connector.activateSession)
    }
}
