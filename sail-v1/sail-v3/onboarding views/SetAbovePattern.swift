//
//  SetConfigs.swift
//  sail-v3
//
//  Created by Alice Mao on 12/10/24.
//

import SwiftUI

struct SetAbovePattern : View {
    @EnvironmentObject var currTest : Test
    
    var body: some View {
        VStack{
            Text("**Set Above Pattern**")
                .font(.system(size: 20))
                .padding(.bottom)
            
            Picker("Data Type", selection: $currTest.abovePattern) {
                ForEach(MadePatternsList.madePatternsList, id: \.self) { currPattern in
                    if(currPattern.name != "ERROR"){
                        Text(String(describing: currPattern.name))
                    }
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 120)
            
            Text("**Selected:** \(currTest.abovePattern.name)")
            Text("**Description:** \(currTest.abovePattern.description)")
            
        }.padding(30)
    }
}
