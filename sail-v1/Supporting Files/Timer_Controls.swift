//
//  Timer_Controls.swift
//  sail-v1
//
//  Created by Alice Mao on 12/8/23.
//

import Foundation
import HealthKit
import SwiftUI

class TimerControls: NSObject, ObservableObject{
    static let time = TimerControls()
    
    @Published var end:Bool = true
    
    @Published var patternObject:Pattern = Pattern()
    @Published var currentData = 160.0
    
    @ObservedObject var ExtendedSess = ExtendedSession()
    
    
    // Deals with stopping timer early and displaying start/stop button
    public func toggleEnd(){
        print("toggle end \(end)")
        self.end = !end
    }

    
    // Sets patternObject to a given Pattern
    public func setPattern(pattern: Pattern){
        self.patternObject = pattern
        print("set pattern: \(pattern)")
    }
    
    
    // Controls the overall timing of playing haptics
    public func overallTimer(realData:Bool, randomData:Bool){
        
        ExtendedSess.startExtendedSession()
        print("start overall timer")
        
        var index = 0
        var dataArr = [150.0, 160.0, 170.0, 150.0]
        self.currentData = dataArr[index]
        
        if randomData{
            dataArr = randomDataArray()
            self.currentData = dataArr[index]
            print(dataArr)
        }
        
        if realData{
            HealthKitData.getSample(type: patternObject.type) { (sample, error) in
                
                guard let sample = sample else {
                    if let error = error {
                        print(error)
                    }
                    return
                }
                
                let unit = DataTypes.getUnits(type: self.patternObject.type)
                let rawValue = sample.quantity.doubleValue(for: unit)
         
                self.currentData = round(rawValue * 100) / 100.0
            }
        } else{
            playHaptic(val: self.currentData)
        }

        index += 1
        
        Timer.scheduledTimer(withTimeInterval: patternObject.timeOverall, repeats: true){ timer in
            if(index >= dataArr.count && !realData) || index >= 1000 {
                print("done with overall")
            
                timer.invalidate()
                self.ExtendedSess.stopExtendedSession()
                self.end = true
                return
            } else if self.end{
                print("done with overall")
                self.ExtendedSess.stopExtendedSession()
                self.end = true
                timer.invalidate()
                return
            }
            
            if realData{
                HealthKitData.getSample(type: self.patternObject.type) { (sample, error) in
                    
                    guard let sample = sample else {
                        if let error = error {
                            print(error)
                        }
                        return
                    }
                    
                    let unit = DataTypes.getUnits(type: self.patternObject.type)
                    let rawValue = sample.quantity.doubleValue(for: unit)
             
                    self.currentData = round(rawValue * 100) / 100.0
                    self.playHaptic(val: self.currentData)
                }
            } else{
                self.currentData = dataArr[index]
                self.playHaptic(val: self.currentData)
            }
            
            index += 1
        }
    }
    
    // Determine which haptic pattern to play and for how li=ong given a value
    public func playHaptic(val: Double){
        var currPattern: [Haptics]
        var timeBetween: [Double]
        
        let target = patternObject.target
        
        if val < (target - patternObject.range){
            currPattern = patternObject.underPattern.HapticArray
            timeBetween = patternObject.underPattern.duration
            print("under: \(val)")
        }
        else if val > (target + patternObject.range){
            currPattern = patternObject.abovePattern.HapticArray
            timeBetween = patternObject.abovePattern.duration
            print("above: \(val)")
        }
        else {
            currPattern = patternObject.atPattern.HapticArray
            timeBetween = patternObject.atPattern.duration
            print("at: \(val)")
        }
        
        startTime(currPattern: currPattern, timeBetweenArr: timeBetween)
    }
    
    // Plays a specific haptic pattern for a given amount of time
    public func startTime(currPattern: [Haptics], timeBetweenArr: [Double]){
        if currPattern.count == 0{
            Timer.scheduledTimer(withTimeInterval: patternObject.timeOverall, repeats: false) { timer in
            }
            return
        }
        
        var index = 0
        var timeIndex = 0
        var timeBetween = timeBetweenArr[timeIndex]
        Timer.scheduledTimer(withTimeInterval: timeBetween, repeats: true) { timer in
            
            // Contitions to end timer
            if (Double(index) * timeBetween) >= self.patternObject.timeOverall {
                timer.invalidate()
                return
            } else if self.end{
                timer.invalidate()
                self.end = true
                return
            }
      
                let currHaptic = currPattern[index % currPattern.count]
                Haptics.play(currHaptic: currHaptic)
                index += 1
                timeIndex += 1
                timeBetween = timeBetweenArr[timeIndex % timeBetweenArr.count]
        }
    }
}
