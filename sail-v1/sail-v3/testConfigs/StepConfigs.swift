//
//  SetConfigs.swift
//  sail-v3
//
//  Created by Alice Mao on 12/10/24.
//

import SwiftUI

struct SetStepConfigs : View {
    @EnvironmentObject var currTest : Test
    
    var body: some View {
        VStack{
            HStack{
                Text("Starting Value")
                TextField("starting value",value: $currTest.startVal, format: .number)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            
            HStack{
                Text("End Value")
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
                Text("Step Duration")
                TextField("step",value: $currTest.stepDuration, format: .number)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
        }
    }
}
