//
//  SelectTestView.swift
//  sail-v3
//
//  Created by Alice Mao on 12/10/24.
//

import Foundation
import SwiftUI

struct SummaryView : View{
    @EnvironmentObject private var currTest : Test
    @EnvironmentObject var connector: ConnectToWatch
    
    var body: some View {
        VStack(alignment: .leading){
            Text("**Summary**")
                .font(.system(size: 20))
                .padding(.bottom)
            Text("**Test:** \(currTest.name)")
            Text("**Above Pattern:** \(currTest.abovePattern.name)\n \(currTest.abovePattern.description)")
            Text("**At Pattern:** \(currTest.atPattern.name)\n \(currTest.atPattern.description)")
            Text("**Under Pattern:** \(currTest.underPattern.name)\n \(currTest.underPattern.description)")
            Text("**Type:** \(currTest.type.rawValue)")
            Text("**Start Val:** \(String(format: "%.2f", currTest.startVal))")
            Text("**End Val:** \(String(format: "%.2f", currTest.endVal))")
            Text("**Step:** \(String(format: "%.2f", currTest.step))")
            Text("**Duration:** \(String(format: "%.2f", currTest.duration))")
            Text("**Under:** \(String(format: "%.2f", currTest.underRange))")
            Text("**Above:** \(String(format: "%.2f", currTest.aboveRange))")
            
            Button(action:{
                connector.sendDataToWatch(sendObject: currTest)
            }){
                Text("Send data to Watch")
            }
        }
    }
}


