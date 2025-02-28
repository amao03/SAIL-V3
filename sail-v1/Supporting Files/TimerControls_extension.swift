////
////  ProcessCompassValues.swift
////  sail-v1
////
////  Created by Alice Mao on 8/6/24.
////
//
//import Foundation
//
//extension TimerControls{
//    func setCurrentValue(){
//        let type = test.type
//        switch (type){
//        case DataType.distance, DataType.heartrate, DataType.cycling:
//            HealthKitData.getSample(type: type) { (sample, error) in
//                guard let sample = sample else {
//                    if let error = error {
//                        print(error)
//                    }
//                    return
//                }
//                
//                let unit = DataTypes.getUnits(type: type)
//                let rawValue = sample.quantity.doubleValue(for: unit)
//                print(rawValue)
//                self.currentData = round(rawValue * 100) / 100.0
//            }
//            
//        case DataType.fake:
//            currentData = fakeDataArr[fakeDataIndex]
//            fakeDataIndex += 1
//            
//        case DataType.random:
//            currentData = Double(Int.random(in: 0..<3))
//        
//        case DataType.altitude:
//            currentData = Double(compass.altitude)
//            
//        case DataType.direction:
//            currentData = Double(compass.direction)
//        case DataType.rower:
////            currentData = Double(fetchData.strokePower)
//            currentData = Double(compass.direction)
//        }
//        
//        print("Val: \(currentData)")
//    }
//    
//    func determinePattern(){
//        switch (test.type){
//        case DataType.fake, DataType.random:
//            setCurrentFakePattern()
//        default:
//            setCurrentPattern()
//        }
//    }
//    
//    func setCurrentPattern(){
//        let target = test.target
//        
//        if currentData < (target - test.underRange){
//            currPattern = test.underPattern
//            currPattern.animationState = AnimationState.under
//        }
//        else if currentData > (target + test.aboveRange){
//            currPattern = test.abovePattern
//            currPattern.animationState = AnimationState.above
//        }
//        else {
//            currPattern = test.atPattern
//            currPattern.animationState = AnimationState.at
//        }
//    }
//    
//    func setCurrentFakePattern(){
//        if currentData == 0{
//            currPattern = test.underPattern
//            currPattern.animationState = AnimationState.under
//        }
//        else if currentData == 2{
//            currPattern = test.abovePattern
//            currPattern.animationState = AnimationState.above
//        }
//        else {
//            currPattern = test.atPattern
//            currPattern.animationState = AnimationState.at
//        }
//        print("Set Pattern: \(currPattern)")
//    }
//}
