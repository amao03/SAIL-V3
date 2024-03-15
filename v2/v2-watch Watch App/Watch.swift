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
    
    
    public func playOnWatch(){
        print("play")
        
        DispatchQueue.main.async {
            print("off receive")
            connector.received = false
        }
        
        if connector.pattern.HapticArray.count == 0{
            return
        }
        
        var index = 0
        Timer.scheduledTimer(withTimeInterval: connector.pattern.duration, repeats: true) { timer in
            print("playing")
            // Contitions to end timer
            if index  > 15{
                timer.invalidate()
//                playing = !playing
//
                return
            }
          
            let currHaptic = connector.pattern.HapticArray[index % connector.pattern.HapticArray.count]
            Haptics.play(currHaptic: currHaptic)
            index += 1
        }
    }
    
    
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
                    let _ = self.playOnWatch()
                    Text("asdffsdlfkjl")
                }
                
                Text("**Pattern:** \n \(connector.pattern.description)")
                Text("**Pattern:** \n \(connector.pattern.name)")

            }
            else{
                Text("awaiting info from phone")
            }
        }
//        .onAppear(perform: startSession)
    }
}
