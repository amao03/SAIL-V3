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
    
    var body : some View{
        TabView{
            SelectTestView().environmentObject(currTest)
            SelectDataTypeView().environmentObject(currTest)
            SetConfigs().environmentObject(currTest)
            SetAbovePattern().environmentObject(currTest)
            SetAtPattern().environmentObject(currTest)
            SetUnderPattern().environmentObject(currTest)
            SummaryView().environmentObject(currTest)
            StartTestView().environmentObject(currTest).environmentObject(connector)
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .onAppear(perform: connector.activateSession)
    }
}
