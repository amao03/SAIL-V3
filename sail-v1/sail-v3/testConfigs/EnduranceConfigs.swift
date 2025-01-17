//
//  SetConfigs.swift
//  sail-v3
//
//  Created by Alice Mao on 12/10/24.
//

import SwiftUI

struct SetEnduranceConfigs : View {
    @EnvironmentObject var currTest : Test
    
    var body: some View {
        VStack{
            HStack{
                Text("Target")
                TextField("duration",value: $currTest.target, format: .number)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            HStack{
                Text("Test Duration")
                TextField("Test Duration",value: $currTest.testDuration, format: .number)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
        }
    }
}
