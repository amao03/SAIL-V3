//
//  SelectTestView.swift
//  sail-v3
//
//  Created by Alice Mao on 12/10/24.
//

import Foundation
import SwiftUI

struct SelectTestView : View{
    @EnvironmentObject private var currTest : Test

    var body: some View {
        VStack{
            Text("**Select a Test**")
                .font(.system(size: 20))
                .padding(.bottom)
            Picker("Test", selection: $currTest.name) {
                ForEach(TestList.tests, id: \.self) { currCase in
                    Text(currCase)
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 120)
        }.padding(30)
        
    }
}

