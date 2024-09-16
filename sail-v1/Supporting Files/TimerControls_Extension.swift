//
//  ProcessCompassValues.swift
//  sail-v1
//
//  Created by Alice Mao on 8/6/24.
//

import Foundation

extension TimerControls{
    func setCurrentValue(){
        let type = connector.pattern.type
        
        switch (type){
        case DataType.distance, DataType.heartrate, DataType.cycling:
            HealthKitData.getSample(type: type) { (sample, error) in
                guard let sample = sample else {
                    if let error = error {
                        print(error)
                    }
                    return
                }
                
                let unit = DataTypes.getUnits(type: type)
                let rawValue = sample.quantity.doubleValue(for: unit)
                print(rawValue)
                self.currentData = round(rawValue * 100) / 100.0
            }
            
        case DataType.fake:
            currentData = fakeDataArr[fakeDataIndex]
            fakeDataIndex += 1
            
        case DataType.random:
            currentData = Double(Int.random(in: 0..<3))
        
        case DataType.altitude:
            currentData = Double(connector.altitude)
            
        case DataType.direction:
            currentData = Double(connector.direction)
        case DataType.rower:
            currentData = Double(connector.rower)
        }
        
        print("Val: \(currentData)")
    }
    
    func determinePattern(){
        switch (connector.pattern.type){
        case DataType.fake, DataType.random:
            setCurrentFakePattern()
        default:
            setCurrentPattern()
        }
    }
    
    func setCurrentPattern(){
        let target = connector.pattern.target
        
        if currentData < (target - connector.pattern.range){
            currPattern = connector.pattern.underPattern.HapticArray
            timeBetween = connector.pattern.underPattern.duration
            colorState = AnimationState.under
        }
        else if currentData > (target + connector.pattern.range){
            currPattern = connector.pattern.abovePattern.HapticArray
            timeBetween = connector.pattern.abovePattern.duration
            colorState = AnimationState.above
        }
        else {
            currPattern = connector.pattern.atPattern.HapticArray
            timeBetween = connector.pattern.atPattern.duration
            colorState = AnimationState.at
        }
//        print("Set Pattern: \(currPattern)   timeBetween: \(timeBetween)")
    }
    
    func setCurrentFakePattern(){
        if currentData == 0{
            currPattern = connector.pattern.underPattern.HapticArray
            timeBetween = connector.pattern.underPattern.duration
            colorState = AnimationState.under
        }
        else if currentData == 2{
            currPattern = connector.pattern.abovePattern.HapticArray
            timeBetween = connector.pattern.abovePattern.duration
            colorState = AnimationState.above
        }
        else {
            currPattern = connector.pattern.atPattern.HapticArray
            timeBetween = connector.pattern.atPattern.duration
            colorState = AnimationState.at
        }
        print("Set Pattern: \(currPattern)   timeBetween: \(timeBetween)")
    }
}
