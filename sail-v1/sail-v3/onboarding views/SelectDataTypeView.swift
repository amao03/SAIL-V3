//
//  SelectTestView.swift
//  sail-v3
//
//  Created by Alice Mao on 12/10/24.
//

import Foundation
import SwiftUI

struct SelectDataTypeView : View{
    @EnvironmentObject var currTest : Test

    var body: some View {
        VStack{
            Text("**Select a Data Type**")
                .font(.system(size: 20))
                .padding(.bottom)
            Picker("Data Type", selection: $currTest.type) {
                ForEach(DataType.allCases, id: \.self) { currCase in
                    Text(String(describing: currCase))
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 120)
        }.padding(20)
    }
}

