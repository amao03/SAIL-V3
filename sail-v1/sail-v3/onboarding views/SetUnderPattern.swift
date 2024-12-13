//
//  SetConfigs.swift
//  sail-v3
//
//  Created by Alice Mao on 12/10/24.
//

import SwiftUI

struct SetUnderPattern : View {
    @EnvironmentObject var currTest : Test
    
    var body: some View {
        VStack{
            Text("**Set Under Pattern**")
                .font(.system(size: 20))
                .padding(.bottom)
            
            Picker("Data Type", selection: $currTest.underPattern) {
                ForEach(MadePatternsList.madePatternsList, id: \.self) { currPattern in
                    if(currPattern.name != "ERROR"){
                        Text(String(describing: currPattern.name))
                    }
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 120)
            
            Text("**Selected:** \(currTest.underPattern.name)")
            Text("**Description:** \(currTest.underPattern.description)")
            
        }.padding(30)
    }
}
