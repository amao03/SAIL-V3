//
//  Haptics.swift
//  sail-v1
//
//  Created by Alice Mao on 12/7/23.
//

import Foundation
import SwiftUI
import HealthKit


struct Haptics: Hashable, Identifiable, Codable{
    var id: String { name }
    var name: String
    var type: String
    
    
    
    static func play(currHaptic: Haptics){
#if os(watchOS)
        if currHaptic.name == "notification" { WKInterfaceDevice.current().play(.notification) }
        else if currHaptic.name == "directionUp" { WKInterfaceDevice.current().play(.directionUp)}
        else { WKInterfaceDevice.current().play(.notification) }
#endif
    }
}

struct HapticsList{
    static var WatchHapticsList:[Haptics] = [
        Haptics(name: "notification", type: "watch"),
        Haptics(name: "directionUp", type: "watch"),
    ]
}

