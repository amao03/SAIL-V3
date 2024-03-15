//
//  Watch.swift
//  v2-watch Watch App
//
//  Created by Alice Mao on 3/1/24.
//

import Foundation
import SwiftUI

struct WatchView: View{
    @ObservedObject var connector = ConnectToWatch.connect
    @ObservedObject var ExtendedSess = ExtendedSession()
    @State var playing = true
    @ObservedObject var pattern = MadePattern()
    @State var previousReceived = true
    
    func toggleEnd(){
        print("toggle end \(playing)")
        self.playing = !playing
    }
    
    private func startSession(){
        print("start session")
        ExtendedSess.startExtendedSession()
    }
    
    private func endSession(){
        print("end session")
        ExtendedSess.stopExtendedSession()
    }
    
    public func updateHaptic(newPattern: MadePattern){
        print("update pattern")
//        pattern = newPattern
    }
    @State var lastTriggered = NSDate()
    @State var dynamicInterval = 1.0
    @State var timerInterval = 0.1
    
    @State var timer: Timer?
    
    func startTimer() {
        var index = 0
        
        timer = .scheduledTimer(withTimeInterval: connector.pattern.duration, repeats: true) { timer in
            if playing{
                timer.invalidate()
                print("end timer")
                return
            }
//            else if connector.received != previousReceived{
//                timer.invalidate()
//                previousReceived = connector.received
//                print("end timer - received")
//                return
//            }
          
            let currHaptic = connector.pattern.HapticArray[index % connector.pattern.HapticArray.count]
            print("currHaptic: \(connector.pattern.name)")
            print("duration: \(connector.pattern.duration)")
            Haptics.play(currHaptic: currHaptic)
            index += 1
        }
    }
    
    func resetTimer() {
        
        DispatchQueue.main.async {
            print("off receive")
            connector.received = false
            timer?.invalidate()
            startTimer()
        }
        
    }
    
//    public func playOnWatch(){
//        print("play")
//        
////        DispatchQueue.main.async {
////            print("off receive")
////            connector.received = false
////        }
//        
//        if connector.pattern.HapticArray.count == 0{
//            return
//        }
//        
//        
//        Timer.scheduledTimer(withTimeInterval: connector.pattern.duration, repeats: true) { timer in
//            if playing{
//                timer.invalidate()
//                print("end timer")
//                return
//            } else if connector.received != previousReceived{
//                timer.invalidate()
//                previousReceived = connector.received
//                print("end timer - received")
//                return
//            }
//          
//            let currHaptic = connector.pattern.HapticArray[index % connector.pattern.HapticArray.count]
//            print("currHaptic: \(connector.pattern.name)")
//            print("duration: \(connector.pattern.duration)")
//            Haptics.play(currHaptic: currHaptic)
//            index += 1
//        }
//        
//        Timer.scheduledTimer(withTimeInterval: connector.pattern.duration, repeats: true) { timer in
//            if playing{
//                timer.invalidate()
//                print("end timer")
//                return
//            } else if connector.received == previousReceived{
//                timer.invalidate()
//                previousReceived = connector.received
//                print("end timer - received")
//                return
//            }
//          
//            let currHaptic = connector.pattern.HapticArray[index % connector.pattern.HapticArray.count]
//            print("currHaptic: \(connector.pattern.name)")
//            print("duration: \(connector.pattern.duration)")
//            Haptics.play(currHaptic: currHaptic)
//            index += 1
//        }
////        while !playing{
////            let currentDate = NSDate()
////            if(currentDate.timeIntervalSince(lastTriggered as Date) >= connector.pattern.duration) {
////                // This will only be called every dynamicInterval seconds
////                // Now call getDifficulty and/or update your dynamicInterval
////                let currHaptic = connector.pattern.HapticArray[index % connector.pattern.HapticArray.count]
////                print("currHaptic: \(connector.pattern.name)")
////                print("duration: \(connector.pattern.duration)")
////                Haptics.play(currHaptic: currHaptic)
////                index += 1
////                
////                lastTriggered = currentDate
////            }
////        }
//
//    }
    
    
    var body: some View {
        VStack{
            if connector.receivedInitial{
                if playing{
                    Button(action:{
                        startSession()
                        print("start")
                        toggleEnd()
                    }){
                        Text("Start")
                    }
                    

                }
                else{
                    Button(action:{
                        print("end")
                        toggleEnd()
                        endSession()
                    }){
                        Text("End")
                    }
                }
                
                if connector.received && !playing{
                    let _ = self.resetTimer()
                }
                
                Text("**Pattern:** \n \(connector.pattern.description)")
                Text("**Pattern:** \n \(connector.pattern.name)")

            }
            else{
                Text("awaiting info from phone")
            }
        }
    }
}
