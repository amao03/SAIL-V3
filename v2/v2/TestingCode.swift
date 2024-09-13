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
    var dataArr = [0, 1, 2, 0]
    @Binding var currPattern:MadePattern
    @Binding var previousPattern:MadePattern
    
    
    var body: some View {
            Section(header: Text("Fake Data")) {
                Button(action:{
                    i = 0
                    runProgram = true
                    evaluateIntervalFakeData(val: Int(dataArr[i]))
                    do{
                        if currPattern.id != previousPattern.id {
                            previousPattern = currPattern
                            connector.sendDataToWatch(sendObject: currPattern)
                        }
                        i += 1
                        
                        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
                            if i >= 4{
                                timer.invalidate()
                                runProgram = false
                                currPattern = MadePatternsList.getPatternByName("END")!
                                connector.sendDataToWatch(sendObject: currPattern)
                                showAwait = true
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
                    } catch Errors.SessionNotReachable{
                        print("error")
                    }
                }){
                    Text("Send fake data to Watch")
                }
                
                Button(action:{
                    var i = 0
                    var val = Int.random(in: 0..<3)
                    runProgram = true
                    evaluateIntervalFakeData(val: val)
                    if currPattern.id != previousPattern.id {
                        previousPattern = currPattern
                        connector.sendDataToWatch(sendObject: currPattern)
                    }
                    i += 1
                    Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
//                        if i >= 5{
//                            timer.invalidate()
//                            currPattern = MadePatternsList.getPatternByName("END")!
//                            connector.sendDataToWatch(sendObject: currPattern)
//                            print("end test")
//                            return
//                        }
                        if !runProgram{
                            timer.invalidate()
                            print("ending random data")
                            return
                        }
                        
                        val = Int.random(in: 0..<3)
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
        if val == 0{
            currPattern = protocolObj.pattern.underPattern
            currPattern.animationState = AnimationState.under
        }
        else if val == 2{
            currPattern = protocolObj.pattern.abovePattern
            currPattern.animationState = AnimationState.above
        } else{
            currPattern = protocolObj.pattern.atPattern
            currPattern.animationState = AnimationState.at
        }
    }
}
