//
//  Data_Types.swift
//  sail-v1
//
//  Created by Alice Mao on 12/7/23.
//

import Foundation
import HealthKit


enum DataType:CaseIterable, Codable, Hashable {
    case random, fake, heartrate, distance, cycling, direction, altitude, rower
}


struct DataTypes{
    
    // Returns respective HKQUantityTypeIdentifier given a respective type
    static func getDataType(type: DataType) -> HKQuantityTypeIdentifier{
        switch type{
        case .distance:
            return .distanceWalkingRunning
        case .heartrate:
            return .heartRate
        case .cycling:
            return .cyclingPower
        default:
            return .distanceWalkingRunning
        }
    }
    
    // Returns respective HKQUantityTypeIdentifier given a respective type
    static func getUnits(type: DataType) -> HKUnit{
        switch type{
        case .distance:
            return .meter()
        case .heartrate:
            return HKUnit(from: "count/min")
        case .cycling:
            return .watt()
        default:
            return .meter()
        }
    }
}
