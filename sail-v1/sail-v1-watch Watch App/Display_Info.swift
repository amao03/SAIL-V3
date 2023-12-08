//
//  Display_INfo.swift
//  sail-v1-watch Watch App
//
//  Created by Alice Mao on 12/8/23.
//

import Foundation
import Foundation
import SwiftUI

struct DisplayInfo:View{
    @Binding var currPattern:Pattern
    
    var body: some View{
        ScrollView{
            VStack(alignment: .leading){
                Group{
                    Text("**Under Pattern:** \n \(currPattern.underPattern.description)")
                    Spacer()
                    Text("**At Pattern:** \n \(currPattern.atPattern.description)")
                    Spacer()
                    Text("**Above Pattern:** \n \(currPattern.abovePattern.description)")
                }
                Spacer()
                
                Text("**Overall Time:** \(String(format: "%.2f", currPattern.timeOverall))")
                Spacer()
                Text("**Type:** \(currPattern.type)")
                Text("**Target:** \(String(format: "%.2f", currPattern.target))")
                Text("**Range:** \(String(format: "%.2f", currPattern.range))")
            }
        }
    }
}

