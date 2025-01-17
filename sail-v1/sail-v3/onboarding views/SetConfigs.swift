//
//  SetConfigs.swift
//  sail-v3
//
//  Created by Alice Mao on 12/10/24.
//

import SwiftUI

struct SetConfigs : View {
    @EnvironmentObject var currTest : Test
    
    var body: some View {
        VStack{
            Text("**Set Test Configs**")
                .font(.system(size: 20))
                .padding(.bottom)
            
            HStack{
                Text("How often data updates")
                TextField("duration",value: $currTest.updateData, format: .number)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            
            HStack{
                Text("Above range buffer")
                TextField("duration",value: $currTest.aboveRange, format: .number)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            
            HStack{
                Text("Below range buffer")
                TextField("duration",value: $currTest.underRange, format: .number)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
        
            if(currTest.name == "Step"){
                SetStepConfigs()
            } else if(currTest.name == "Endurance"){
                SetEnduranceConfigs()
            } else if (currTest.name == "Pyramid"){
                SetPyramidConfigs()
            } else{
                SetJustRowConfigs()
            }
            
            Button("Set configs") {
                hideKeyboard()
            }
        }.padding(30)
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
