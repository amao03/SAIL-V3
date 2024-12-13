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
                Text("Starting threshold")
                TextField("starting value",value: $currTest.startVal, format: .number)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            
            HStack{
                Text("End threshold")
                TextField("End value",value: $currTest.endVal, format: .number)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            HStack{
                Text("Step")
                TextField("step",value: $currTest.step, format: .number)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            HStack{
                Text("Duration between steps")
                TextField("duration",value: $currTest.duration, format: .number)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            HStack{
                Text("Target")
                TextField("duration",value: $currTest.target, format: .number)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
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

//struct SetConfigs_Preview : PreviewProvider{
//    @State static var currObject = Test()
//    static var previews: some View {
//        SetConfigs(currTest: $currObject)
//    }
//}
