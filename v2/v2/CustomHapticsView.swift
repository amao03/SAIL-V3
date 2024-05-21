//
//  CustomHaptics.swift
//  v2
//
//  Created by Alice Mao on 4/12/24.
//

import Foundation
import SwiftUI

struct CustomHapticsView:View {
    @Binding var selectedProtocol:Pattern
    
    var body: some View {
        Text("**Selected:** \(selectedProtocol.atPattern.name)")
        Text("**Description:**  \(selectedProtocol.atPattern.description)")
        Text("Under Pattern: \(selectedProtocol.underPattern.name)")
        Text("At Pattern: \(selectedProtocol.atPattern.name)")
        Text("Above Pattern: \(selectedProtocol.abovePattern.name)")
    }
}

//#Preview {
//    @State var selectedProtocol = Pattern()
//    CustomHapticsView(selectedProtocol: $selectedProtocol)
//}
