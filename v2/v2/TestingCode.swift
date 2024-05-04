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
    var dataArr = [0, 120, 200, 0]
    @Binding var currPattern:MadePattern
    @Binding var previousPattern:MadePattern
    
    
    var body: some View {
            Section(header: Text("Fake Data")) {
                Button(action:{
                    i = 0
                    evaluateIntervalFakeData(val: Int(dataArr[i]))
                    if currPattern.id != previousPattern.id {
                        previousPattern = currPattern
                        connector.sendDataToWatch(sendObject: currPattern)
                    }
                    i += 1
                    Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
                        if i >= 4{
                            timer.invalidate()
                            print("end test")
                            return
                        }
                        
                        evaluateIntervalFakeData(val: Int(dataArr[i]))
                        if currPattern.id != previousPattern.id {
                            previousPattern = currPattern
                            connector.sendDataToWatch(sendObject: currPattern)
                        }
                        i += 1
                    }
                }){
                    Text("Send fake data to Watch")
                }
                
                Button(action:{
                    var i = 0
                    var val = Int.random(in: 90..<150)
                    evaluateIntervalFakeData(val: val)
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
                        val = Int.random(in: 90..<150)
                        evaluateIntervalFakeData(val: val)
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
    
    private func evaluateIntervalFakeData(val:Int){
        print(val)
        if val < Int(protocolObj.pattern.target - protocolObj.pattern.range){
            currPattern = protocolObj.pattern.underPattern
            currPattern.animationState = AnimationState.below
        }
        else if val > Int(protocolObj.pattern.target + protocolObj.pattern.range){
            currPattern = protocolObj.pattern.abovePattern
            currPattern.animationState = AnimationState.above
        } else{
            currPattern = protocolObj.pattern.atPattern
            currPattern.animationState = AnimationState.at
        }
    }
}
