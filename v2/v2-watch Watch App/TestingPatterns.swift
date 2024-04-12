//
//  TestingPatterns.swift
//  v2-watch Watch App
//
//  Created by Alice Mao on 4/12/24.
//

import Foundation
import SwiftUI

struct TestingPatterns : View {
    @ObservedObject var underPatter:MadePattern
    @ObservedObject var atPatter:MadePattern
    @ObservedObject var abovePattern:MadePattern
    @State var timer: Timer?
    
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
    
    var body: some View {
        Button(action:{
            startTimer(singlePattern: underPatter)
            print("play above")
        }){
            Text("Above Pattern")
        }
        Button(action:{
            startTimer(singlePattern: atPatter)
            print("play at")
        }){
            Text("At Pattern")
        }
        Button(action:{
            startTimer(singlePattern: abovePattern)
            print("play under")
        }){
            Text("Under Pattern")
        }
    }
}
