//
//  Watch.swift
//  v2-watch Watch App
//
//  Created by Alice Mao on 3/1/24.
//

import Foundation
import SwiftUI

struct WatchView: View {
    @ObservedObject var connector = ConnectToWatch.connect
    @ObservedObject var ExtendedSess = ExtendedSession()
    
    @State var timer: Timer?
    @State var animationState: AnimationState
    
    @State private var animationAmount = 1.0;
    @State private var animationDuration = 1.0;
    
    func toggleEnd(){
        print("toggle end \(connector.playing)")
        connector.playing = !connector.playing
    }
    
    private func startSession(){
        if ExtendedSess.session.state != WKExtendedRuntimeSessionState.running{
            print("start session")
            ExtendedSess.startExtendedSession()
        }
    }
    
    private func endSession(){
        if ExtendedSess.session.state == WKExtendedRuntimeSessionState.running{
            print("end session")
            ExtendedSess.stopExtendedSession()
        }
    }
    
    func startTimer() {
        var index = 0
        
        animationState = connector.pattern.animationState
        
        timer = .scheduledTimer(withTimeInterval: connector.pattern.duration, repeats: true) { timer in
            if !connector.playing{
                timer.invalidate()
                print("end timer")
                return
            }
            
            let currHaptic = connector.pattern.HapticArray[index % connector.pattern.HapticArray.count]
//            print("currHaptic: \(connector.pattern.name)")
//            print("duration: \(connector.pattern.duration)")
            Haptics.play(currHaptic: currHaptic)
            index += 1
        }
    }
    
    func updateTimer() {
        DispatchQueue.main.async {
            print("updating")
            connector.received = false
            timer?.invalidate()
            connector.playing = true
            startSession()
            startTimer()
        }
    }
    
    func resetTimer(){
            DispatchQueue.main.async {
            print("resetTimer receive")
            timer?.invalidate()
        }
    }
    
    private func update(){
        print("updating timer")
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false){ timer in
            connector.updating = false
            timer.invalidate()
        }
    }
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack (alignment: .leading, spacing: 20){
                    if !runProgram{
                        Text("awaiting info from phone")
                        let _ = self.resetTimer()
                    } else if connector.pattern.name == "END"{
                        Text("awaiting info from phone")
                        let _ = self.resetTimer()
                    }
                    else{
                        IndicatorView(animationState: animationState)
                        let _ = self.startSession()
                        Button(action:{
                            print("end")
                            let _ = self.resetTimer()
                            toggleEnd()
                            endSession()
                            runProgram = false
                        }){
                            Text("End")
                        }
                    }
                 
                    //Buttons for user to try patterns before test begins
                    if(connector.patternPackageReceived){
                        if connector.updating{
                            let _ = self.update()
                            Text("updating...")
                        }
                        
                        NavigationLink(destination: CarouselView(underPattern: connector.patternPackage.underPattern, atPattern: connector.patternPackage.atPattern, abovePattern: connector.patternPackage.abovePattern)) {
                            Text("Test Patterns")
                        }
                    }
                    
                    if connector.received && runProgram{
                        let _ = self.updateTimer()
                    }
                }
            }
        }
        .onAppear(perform: ExtendedSess.startExtendedSession)
//        .onAppear(perform: startSession)
    }
}

#Preview {
    WatchView( animationState: AnimationState.at)
}

