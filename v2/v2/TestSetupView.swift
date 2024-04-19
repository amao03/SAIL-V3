//
//  TestSetupView.swift
//  v2
//
//  Created by Lucas Drummond on 2/26/24.
//
import SwiftUI


struct TestSetupView: View {
    @Binding var selectProtocol: Protocols
    
    var body: some View {
        Section{
            VStack{
                    Picker("Protocol:", selection: $selectProtocol) {
                        ForEach(ProtocolList.protocolList, id: \.self) { item in
                            Text(item.name).tag(item)
                        }
                    }
                    
                    HStack{
                        Text("Target")
                        TextField("Target",value: $selectProtocol.pattern.target, format: .number)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                    }
                    
                    HStack{
                        Text("Range")
                        TextField("",value: $selectProtocol.pattern.range, format: .number)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                    }
                    
                    
                    Picker("Under Pattern:", selection: $selectProtocol.pattern.underPattern) {
                        ForEach(MadePatternsList.madePatternsList, id: \.self) { item in
                            if item.name != "ERROR"{
                                Text(item.name).tag(item.name)
                            }
                        }
                    }
                    
                    Picker("At Pattern:", selection: $selectProtocol.pattern.atPattern) {
                        ForEach(MadePatternsList.madePatternsList, id: \.self) { item in
                            if item.name != "ERROR"{
                                Text(item.name).tag(item.name)
                            }
                        }
                    }
                    
                    Picker("Above Pattern:", selection: $selectProtocol.pattern.abovePattern) {
                        ForEach(MadePatternsList.madePatternsList, id: \.self) { item in
                            if item.name != "ERROR"{
                                Text(item.name).tag(item.name)
                            }
                        }
                }
            }
        } header: {
            Text("Setup")
        }
    }
}
