//
//  Data_Types.swift
//  sail-v1
//
//  Created by Alice Mao on 12/7/23.
//

import Foundation
import HealthKit

struct DataTypes{
    var typesArr = ["distance", "heartrate", "cycling power"]
    
    
    // Returns respective HKQUantityTypeIdentifier given a respective type
    static func getDataType(type: String) -> HKQuantityTypeIdentifier{
        switch type{
        case "distance":
            return .distanceWalkingRunning
        case "heartrate":
            return .heartRate
        case "cycling power":
            return .cyclingPower
        default:
            return .distanceWalkingRunning
        }
    }
    
    // Returns respective HKQUantityTypeIdentifier given a respective type
    static func getUnits(type: String) -> HKUnit{
        switch type{
        case "distance":
            return .meter()
        case "heartrate":
            return HKUnit(from: "count/min")
        case "cycling power":
            return .watt()
        default:
            return .meter()
        }
    }
}
