//
//  TestingCode.swift
//  v2
//
//  Created by Alice Mao on 5/3/24.
//

import Foundation
import SwiftUI


struct TestingCode:View {
    @Binding var protocolObj:Protocols
    @ObservedObject var connector:ConnectToWatch
    @State var i = 0
    var dataArr = [150.0, 160.0, 170.0, 150.0]
    @Binding var currPattern:MadePattern
    @Binding var previousPattern:MadePattern
    
    
    var body: some View {
        List{
            Section(header: Text("Fake Data")) {
                Button(action:{
                    i = 0
                    print("val: " , dataArr[i])
                    if dataArr [i] < protocolObj.pattern.target{
                        print("send under")
                        connector.sendDataToWatch(sendObject: protocolObj.pattern.underPattern)
                    }
                    else if dataArr [i] > protocolObj.pattern.target{
                        print("send above")
                        connector.sendDataToWatch(sendObject: protocolObj.pattern.abovePattern)
                    }
                    else{
                        print("send at")
                        connector.sendDataToWatch(sendObject: protocolObj.pattern.atPattern)
                    }
                    i += 1
                    Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
                        if i >= 4{
                            timer.invalidate()
                            print("end test")
                            return
                        }
                        print("val: " , dataArr[i])
                        if dataArr [i] < protocolObj.pattern.target{
                            print("send under")
                            connector.sendDataToWatch(sendObject: protocolObj.pattern.underPattern)
                        }
                        else if dataArr [i] > protocolObj.pattern.target{
                            print("send above")
                            connector.sendDataToWatch(sendObject: protocolObj.pattern.abovePattern)
                        }
                        else{
                            print("send at")
                            connector.sendDataToWatch(sendObject: protocolObj.pattern.atPattern)
                        }
                        i += 1
                    }
                }){
                    Text("Send fake data to Watch")
                }
            }
            
            Section(header: Text("random data")) {
                Button(action:{
                    var i = 0
                    evaluateIntervalFakeData()
                    if currPattern.id != previousPattern.id {
                        previousPattern = currPattern
                        connector.sendDataToWatch(sendObject: currPattern)
                    }
                    i += 1
                    Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
                        if i >= 12{
                            timer.invalidate()
                            print("end test")
                            return
                        }
                        evaluateIntervalFakeData()
                        if currPattern.id != previousPattern.id {
                            previousPattern = currPattern
                            connector.sendDataToWatch(sendObject: currPattern)
                        }
                        i += 1
                    }
                }){
                    Text("Send random data to Watch")
                }
            }
        }
    }
    
    private func evaluateIntervalFakeData(){
        let val = Int.random(in: 0..<3)
        print(val)
        if val == 0{
            currPattern = protocolObj.pattern.underPattern
        }
        else if val == 1{
            currPattern = protocolObj.pattern.abovePattern
        } else{
            currPattern = protocolObj.pattern.atPattern
        }
    }
    
}
