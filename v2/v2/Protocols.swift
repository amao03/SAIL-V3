//
//  Protocols.swift
//  v2
//
//  Created by Alice Mao on 3/1/24.
//

import Foundation
import SwiftUI

class Protocols: Identifiable, Codable, Hashable, ObservableObject{
    static func == (lhs: Protocols, rhs: Protocols) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
    var pattern:Pattern
    var name:String
    var id: String { name }
//    var target:Double
//    var range:Double
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(pattern)
        hasher.combine(name)
    }
    
    init(){
        self.pattern = Pattern(underPattern: MadePatternsList.getPatternByName("super pulse")!, atPattern: MadePatternsList.getPatternByName("heartbeat")!, abovePattern: MadePatternsList.getPatternByName("short-long")!,target: 120, range: 10)
        self.name = "v1"
//        self.target = 160
//        self.range = 10
    }
    
    init( pattern: Pattern, name: String) {
        self.pattern = pattern
        self.name = name
//        self.target = target
//        self.range = range
    }
}

class ProtocolList {
    static var v1 = Protocols(pattern: Pattern(underPattern: MadePatternsList.getPatternByName("super pulse")!, atPattern: MadePatternsList.getPatternByName("heartbeat")!, abovePattern: MadePatternsList.getPatternByName("short-long")!,target: 120, range: 10), name: "V1")
    
    static var v2 = Protocols(pattern: Pattern(underPattern: MadePatternsList.getPatternByName("super pulse")!, atPattern: MadePatternsList.getPatternByName("heartbeat")!, abovePattern: MadePatternsList.getPatternByName("short-long")!,target: 160, range: 10), name: "V2")
    
    static var v3 = Protocols(pattern: Pattern(underPattern: MadePatternsList.getPatternByName("super pulse")!, atPattern: MadePatternsList.getPatternByName("heartbeat")!, abovePattern: MadePatternsList.getPatternByName("short-long")!, target: 160, range: 10), name: "V3")
    
    static var protocolList:[Protocols] = [v1, v2, v3]
        
    static func getProtocolByName(_ name: String) -> Protocols? {
        return protocolList.first(where: {$0.name == name});
    }
}
