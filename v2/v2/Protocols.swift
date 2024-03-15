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
    
    var pattern:Pattern = Pattern(underPattern: MadePatternsList.getPatternByName("heartbeat")!, atPattern: MadePatternsList.getPatternByName("super pulse")!, abovePattern: MadePatternsList.getPatternByName("short-long")!, target: 160.0, range: 0.0)
    var name:String = "v1"
    var id: String { name }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(pattern)
        hasher.combine(name)
    }
    
    init(pattern: Pattern, name: String) {
        self.pattern = pattern
        self.name = name
    }
}

class ProtocolList {
    static var protocolList:[Protocols] = [
        Protocols(pattern: Pattern(underPattern: MadePatternsList.getPatternByName("heartbeat")!, atPattern: MadePatternsList.getPatternByName("super pulse")!, abovePattern: MadePatternsList.getPatternByName("short-long")!, target: 160.0, range: 0.0), name: "V1"),
        Protocols(pattern: Pattern(underPattern: MadePatternsList.getPatternByName("super pulse")!, atPattern: MadePatternsList.getPatternByName("heartbeat")!, abovePattern: MadePatternsList.getPatternByName("short-long")!, target: 160.0, range: 0.0), name: "V2"),
        Protocols(pattern: Pattern(underPattern: MadePatternsList.getPatternByName("super pulse")!, atPattern: MadePatternsList.getPatternByName("heartbeat")!, abovePattern: MadePatternsList.getPatternByName("short-long")!, target: 160.0, range: 0.0), name: "V3"),
    ]
        
    static func getProtocolByName(_ name: String) -> Protocols? {
        return protocolList.first(where: {$0.name == name});
    }
}
