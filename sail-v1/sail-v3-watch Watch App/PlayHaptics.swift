//
//  StartTestTimers.swift
//  sail-v3
//
//  Created by Alice Mao on 1/13/25.
//

import Foundation
import SwiftUI
import HealthKit

final class PlayHaptics: NSObject, ObservableObject{
    static let time = PlayHaptics()
    
    @Published var playingTimer: Timer?
    @Published var currPatternIndex = 0
    
    public func startPlaying(pattern: MadePattern){
        print("start playing haptics")
        
        let currPattern = pattern.HapticArray
        let currHaptic = currPattern[self.currPatternIndex % currPattern.count]

        Haptics.play(currHaptic: currHaptic)
        currPatternIndex += 1
        
        playingTimer = Timer.scheduledTimer(withTimeInterval: pattern.duration, repeats: true) { timer in
            print("Timer fired!")
            
            let currPattern = pattern.HapticArray
            let currHaptic = currPattern[self.currPatternIndex % currPattern.count]
            self.currPatternIndex += 1
            Haptics.play(currHaptic: currHaptic)
        }
    }
    
    public func updatingPlaying(pattern: MadePattern){
        print("updating playing haptics")
        endPlaying()
        startPlaying(pattern: pattern)
    }
    
    public func endPlaying(){
        playingTimer?.invalidate()
        currPatternIndex = 0
    }
}

