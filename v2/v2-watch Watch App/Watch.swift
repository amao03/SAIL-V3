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
    
    public func updateHaptic(newPattern: MadePattern){
        print("update pattern")
//        pattern = newPattern
    }
    
    
    public func playOnWatch(){
        print("play")
        ConnectToWatch.connect.received = false
        if pattern.HapticArray.count == 0{
            return
        }
        
        var index = 0
        Timer.scheduledTimer(withTimeInterval: pattern.duration, repeats: true) { timer in
            print("playing")
            // Contitions to end timer
            if !playing{
                timer.invalidate()
                playing = !playing
                ExtendedSess.stopExtendedSession()
                return
            }
          
            let currHaptic = pattern.HapticArray[index % pattern.HapticArray.count]
            Haptics.play(currHaptic: currHaptic)
            index += 1
        }
    }
    
    
    var body: some View {
        VStack{
            if ConnectToWatch.connect.receivedInitial{
                if ConnectToWatch.connect.received{
                    Button(action:{
                        print("end")
                        toggleEnd()
                    }){
                        Text("Start")
                    }
                    
                }
                let _ = self.playOnWatch()
                Text("**Pattern:** \n \(pattern.description)")
                Text("**Pattern:** \n \(pattern.name)")
            }
            else{
                Text("awaiting info from phone")
            }
        }.onAppear(perform: startSession)
    }
}
