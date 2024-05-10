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
            connector.playing = true
            startSession()
            startTimer()
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
                    if !connector.patternPackageReceived && !connector.receivedInitial{
                        Text("awaiting info from phone")
                    }
                    
                    //Buttons for user to try patterns before test begins
                    if(connector.patternPackageReceived){
                        if connector.updating{
                            let _ = self.update()
                            Text("updating...")
                        }
                        
                        NavigationLink(destination: CarouselView(underPattern: connector.patternPackage.underPattern, atPattern: connector.patternPackage.atPattern, abovePattern: connector.patternPackage.abovePattern)) {
                            Text("Test Patterns")
                        }                    }
                    
                    if connector.receivedInitial{
                        if connector.playing{
                            IndicatorView(animationState: animationState)
                            let _ = self.startSession()
                            Button(action:{
                                print("end")
                                toggleEnd()
                                endSession()
                            }){
                                Text("End")
                            }
                        }
                        else{
                            Button(action:{
                                print("start")
                                toggleEnd()
                                startSession()
                                endSession()
                            }){
                                Text("start")
                            }
//                            Text("test ended")
                        }
                        
                        if connector.received && connector.playing{
                            let _ = self.resetTimer()
                        }
                        
                    }
                }
            }
        }.onAppear(perform: ExtendedSess.startExtendedSession)
    }
}

#Preview {
    WatchView( animationState: AnimationState.at)
}
