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
    var connector = ConnectToWatch.connect
    
    var playingTimer: Timer?
    var currPatternIndex = 0
    
    public func startPlaying(){
        print("start playing haptics")
        
        let currPattern = connector.pattern.HapticArray
        let currHaptic = currPattern[currPatternIndex % currPattern.count]
        currPatternIndex += 1
        Haptics.play(currHaptic: currPattern[currPatternIndex % currPattern.count])
        
        playingTimer = Timer.scheduledTimer(timeInterval: connector.pattern.duration, target: self, selector: #selector(playing), userInfo: nil, repeats: true)
    }
    
    @objc func playing(){
        if(connector.updating){
            endPlaying()
            return
        } else if (connector.stopTest){
            endPlaying()
            return
        }
        
        let currPattern = connector.pattern.HapticArray
        let currHaptic = currPattern[currPatternIndex % currPattern.count]
        currPatternIndex += 1
        Haptics.play(currHaptic: currHaptic)
    }
    
    public func endPlaying(){
        playingTimer?.invalidate()
        currPatternIndex = 0
    }
}

