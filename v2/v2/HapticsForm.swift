//
//  HapticsForm.swift
//  v2
//
//  Created by Alice Mao on 4/12/24.
//

import Foundation
import SwiftUI

struct HapticsForm:View {
    @Binding var currProtocol: Protocols
    @Binding var currPattern:Pattern
    
    var body: some View {
        VStack{
            Form{
                HStack{
                    Text("Target")
                    TextField("Target",value: $currProtocol.pattern.target, format: .number).multilineTextAlignment(.trailing)
                }
                
                HStack{
                    Text("Range")
                    TextField("",value: $currProtocol.pattern.range, format: .number).multilineTextAlignment(.trailing)
                }
                
                Section("Under Pattern", content: {
                    NavigationLink(destination: {
                        MadeHapticsSelector(selectedItems: $currProtocol.pattern.underPattern)
                    }, label: {
                        Text("Select haptics")
                    })
                    Text("**Selected:** \(currProtocol.pattern.underPattern.name)")
                    Text("**Description:** \(currProtocol.pattern.underPattern.description)")
                })
                
                Section("Under Pattern", content: {
                    Picker("Under Pattern:", selection: $currProtocol.pattern.underPattern) {
                        ForEach(MadePatternsList.madePatternsList, id: \.self) { item in
                            if item.name != "ERROR"{
                                Text(item.name)
                            }
                        }
                    }
                    Text("**Selected:** \(currProtocol.pattern.underPattern.name)")
                    Text("**Description:**  \(currProtocol.pattern.underPattern.description)")
                })
                
                Section("At Pattern", content: {
                    Picker("At Pattern:", selection: $currProtocol.pattern.atPattern) {
                        ForEach(MadePatternsList.madePatternsList, id: \.self) { item in
                            if item.name != "ERROR"{
                                Text(item.name)
                            }
                        }
                    }
                    Text("**Selected:** \(currProtocol.pattern.atPattern.name)")
                    Text("**Description:**  \(currProtocol.pattern.atPattern.description)")
                })
                
                Section("Above Pattern", content: {
                    Picker("Above Pattern:", selection: $currProtocol.pattern.abovePattern) {
                        ForEach(MadePatternsList.madePatternsList, id: \.self) { item in
                            if item.name != "ERROR"{
                                Text(item.name)
                            }
                        }
                    }
                    Text("**Selected:** \(currProtocol.pattern.abovePattern.name)")
                    Text("**Description:**  \(currProtocol.pattern.abovePattern.description)")
                })
            }
        }
    }
}
