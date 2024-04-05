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
    @State var timer: Timer?
    
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
    
    func startTimer() {
        var index = 0
        
        timer = .scheduledTimer(withTimeInterval: connector.pattern.duration, repeats: true) { timer in
            if playing{
                timer.invalidate()
                print("end timer")
                return
            }
          
            let currHaptic = connector.pattern.HapticArray[index % connector.pattern.HapticArray.count]
            print("currHaptic: \(connector.pattern.name)")
            print("duration: \(connector.pattern.duration)")
            Haptics.play(currHaptic: currHaptic)
            index += 1
        }
    }
    
    func startTimer(singlePattern: MadePattern ) {
        var index = 0
        let totalDuration  = 6.0
        let startTime = Date()
        
        timer = .scheduledTimer(withTimeInterval: singlePattern.duration, repeats: true) { timer in
            let currentTime = Date()
            let elapsedTime = currentTime.timeIntervalSince(startTime)
            //playing haptic pattern for totalDuration seconds when startTimer is called
            if (elapsedTime >= totalDuration) {
                timer.invalidate()
                return
            }
          
            let currHaptic = singlePattern.HapticArray[index % singlePattern.HapticArray.count]
            print("currHaptic: \(singlePattern.name)")
            print("duration: \(singlePattern.duration)")
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
    
    
    var body: some View {
        VStack{
            //Buttons for user to try patterns before test begins
            if(connector.patternPackageReceived){
                Button(action:{
                    startTimer(singlePattern: connector.patternPackage.abovePattern)
                    print("play above")
                }){
                    Text("Above Pattern")
                }
                Button(action:{
                    startTimer(singlePattern: connector.patternPackage.atPattern)
                    print("play at")
                }){
                    Text("At Pattern")
                }
                Button(action:{
                    startTimer(singlePattern: connector.patternPackage.underPattern)
                    print("play under")
                }){
                    Text("Under Pattern")
                }
            }
            
            else if connector.receivedInitial{
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
