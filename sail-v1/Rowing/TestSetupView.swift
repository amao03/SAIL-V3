//
//  TestSetupView.swift
//  v2
//
//  Created by Lucas Drummond on 2/26/24.
//
import SwiftUI


struct TestSetupView: View {
    @Binding var selectProtocol: Protocols
    @State var playingTimer: Timer?
    @State var timerRunning = false
    @ObservedObject var connector:ConnectToWatch
    
    var body: some View {
        Section{
            VStack{
                    Picker("Protocol:", selection: $selectProtocol) {
                        ForEach(ProtocolList.protocolList, id: \.self) { item in
                            Text(item.name).tag(item)
                        }
                    }.pickerStyle(.menu)
                    
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
                    }.pickerStyle(.menu)
                    
                    Picker("At Pattern:", selection: $selectProtocol.pattern.atPattern) {
                        ForEach(MadePatternsList.madePatternsList, id: \.self) { item in
                            if item.name != "ERROR"{
                                Text(item.name).tag(item.name)
                            }
                        }
                    }.pickerStyle(.menu)
                    
                    Picker("Above Pattern:", selection: $selectProtocol.pattern.abovePattern) {
                        ForEach(MadePatternsList.madePatternsList, id: \.self) { item in
                            if item.name != "ERROR"{
                                Text(item.name).tag(item.name)
                            }
                        }
                }.pickerStyle(.menu)
                
                Button(action:{
                    connector.sendDataToWatch(sendObject: selectProtocol.pattern)
//                    print(connector.patternPackageSent)
                    timerRunning = false
                    playingTimer?.invalidate()
                }){
                    Text("Test Pattern")
                }.padding()
            }
        } header: {
            Text("Setup")
        }
    }
}

