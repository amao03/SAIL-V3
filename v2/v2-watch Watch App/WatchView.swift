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
    @State var playing = true
    @State var timer: Timer?
    @State var animationState: AnimationState = AnimationState.above
    
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
        
        animationState = connector.pattern.animationState
        
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
    
    func resetTimer() {
        DispatchQueue.main.async {
            print("off receive")
            connector.received = false
            timer?.invalidate()
            startTimer()
        }
    }
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack{
                    IndicatorView(animationState: $animationState)
                    
                    //Buttons for user to try patterns before test begins
                    if(connector.patternPackageReceived){
                        NavigationLink(destination: TestingPatterns(underPatter: connector.patternPackage.underPattern, atPatter: connector.patternPackage.atPattern, abovePattern: connector.patternPackage.abovePattern)) {
                            Text("Test Patterns")
                        }
                        Text("Range: \(connector.patternPackage.range)")
                        Text("Target: \(connector.patternPackage.target)")
                        Text("Target: \(connector.patternPackage.underPattern.name)")
                        Text("Target: \(connector.patternPackage.atPattern.name)")
                        Text("Target: \(connector.patternPackage.abovePattern.name)")
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
    }
}

struct IndicatorView: View {
    @Binding var animationState: AnimationState
    @State private var animationAmount = 1.0;
    @State private var animationDuration = 1.0;
    
    private func getColor(_: AnimationState) -> Color {
        switch(animationState) {
            case .above:
                return .pink
            case .at:
                return .blue
            case .below:
                return .green
        }
    }
    
    var body: some View {
        VStack {
            Circle()
                .foregroundColor(getColor(animationState))
                .frame(width: 80, height: 80)
                .scaleEffect(animationAmount)
                .animation(
                    .easeInOut(duration: animationDuration)
                    .repeatForever(autoreverses: true),
                    value: animationAmount
                )
                .onChange(of: animationState) {
                    switch(animationState) {
                    case .above:
                        animationAmount = 0.8
                        animationDuration = 2.0
                    case .at:
                        animationAmount = 1.0
                        animationDuration = 1.0
                    case .below:
                        animationAmount = 1.0
                        animationDuration = 0.5
                    }
                }
                .onAppear {
                    animationAmount = 1.2;
                }
        }
    }
}

#Preview {
    WatchView( animationState: AnimationState.at)
}
