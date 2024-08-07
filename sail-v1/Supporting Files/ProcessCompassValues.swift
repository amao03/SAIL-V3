//
//  ProcessCompassValues.swift
//  sail-v1
//
//  Created by Alice Mao on 8/6/24.
//

import Foundation

var fakeDataIndex = 0

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
            
            if fakeDataIndex == 3 {
                fakeDataIndex = 0
            } else {
                fakeDataIndex += 1
            }
            
        case DataType.random:
            currentData = Double(Int.random(in: 0..<3))
        
        case DataType.altitude, DataType.direction:
            currentData = connector.rawValue
            
        default:
            currentData = connector.rawValue
        }
        
        print("Type: \(type)   Val: \(currentData)")
    }
    
    func setCurrentPattern(){
        let target = connector.pattern.target
        
        if currentData < (target - connector.pattern.range){
            currPattern = connector.pattern.underPattern.HapticArray
            timeBetween = connector.pattern.underPattern.duration
        }
        else if currentData > (target + connector.pattern.range){
            currPattern = connector.pattern.abovePattern.HapticArray
            timeBetween = connector.pattern.abovePattern.duration
        }
        else {
            currPattern = connector.pattern.atPattern.HapticArray
            timeBetween = connector.pattern.atPattern.duration
        }
        print("Set Pattern: \(currPattern)   timeBetween: \(timeBetween)")
    }
}
