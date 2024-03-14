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
    
    
    var pattern:Pattern = Pattern()
    var name:String = ""
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
        Protocols(pattern: Pattern(), name: "V1"),
        Protocols(pattern: Pattern(), name: "V2"),
        Protocols(pattern: Pattern(), name: "V3"),
    ]
        
    static func getProtocolByName(_ name: String) -> Protocols? {
        return protocolList.first(where: {$0.name == name});
    }
}
