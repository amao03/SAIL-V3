//
//  CustomHaptics.swift
//  v2
//
//  Created by Alice Mao on 4/12/24.
//

import Foundation
import SwiftUI

struct CustomHaptics:View{
    @Binding var selectProtocol:Pattern
    
    var body: some View{
        Text("**Selected:** \(selectProtocol.atPattern.name)")
        Text("**Description:**  \(selectProtocol.atPattern.description)")
//        Text("Target: \($selectProtocol.target)")
//        Text("Range: \(selectProtocol.range)")
        Text("Under Pattern: \(selectProtocol.underPattern.name)")
        Text("At Pattern: \(selectProtocol.atPattern.name)")
        Text("Above Pattern: \(selectProtocol.abovePattern.name)")
    }
}
