//
//  Protocols.swift
//  v2
//
//  Created by Alice Mao on 3/1/24.
//

import Foundation

struct Protocols: Hashable, Identifiable{
    var pattern:Pattern = Pattern()
    var name:String = ""
    var id: String { name }
}

struct ProtocolList {
    static var protocolList:[Protocols] = [
        Protocols(name: "V1"),
        Protocols(name: "V2"),
        Protocols(name: "V3"),
    ]
        
    static func getProtocolByName(_ name: String) -> Protocols? {
        return protocolList.first(where: {$0.name == name});
    }
}
