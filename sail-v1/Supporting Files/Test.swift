//
//  Tests.swift
//  SailV3
//
//  Created by Alice Mao on 11/2/24.
//

import Foundation

class Test: Identifiable, Codable, Hashable, ObservableObject{
    static func == (lhs: Test, rhs: Test) -> Bool {
        return lhs.name == rhs.name
    }
    
    @Published var name = "Step"
    @Published var duration = 3.0
    @Published var step = 20.0
    @Published var startVal = 20.0
    @Published var endVal = 60.0
    @Published var underRange = 10.0
    @Published var aboveRange = 10.0
    @Published var target = 20.0
    @Published var abovePattern = MadePatternsList.getPatternByName("super pulse")!
    @Published var atPattern = MadePatternsList.getPatternByName("heartbeat")!
    @Published var underPattern = MadePatternsList.getPatternByName("short-long")!
    @Published var type = DataType.rower
    
    enum CodingKeys: CodingKey {
        case name, duration, step, startVal, endVal, underRange, aboveRange, target, abovePattern, atPattern, underPattern, type
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        duration = try container.decode(Double.self, forKey: .duration)
        step = try container.decode(Double.self, forKey: .step)
        startVal = try container.decode(Double.self, forKey: .startVal)
        endVal = try container.decode(Double.self, forKey: .endVal)
        underRange = try container.decode(Double.self, forKey: .underRange)
        aboveRange = try container.decode(Double.self, forKey: .aboveRange)
        target = try container.decode(Double.self, forKey: .target)
        abovePattern = try container.decode(MadePattern.self, forKey: .abovePattern)
        atPattern = try container.decode(MadePattern.self, forKey: .atPattern)
        underPattern = try container.decode(MadePattern.self, forKey: .underPattern)
        type = try container.decode(DataType.self, forKey: .type)
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(duration, forKey: .duration)
        try container.encode(step, forKey: .step)
        try container.encode(startVal, forKey: .startVal)
        try container.encode(endVal, forKey: .endVal)
        try container.encode(underRange, forKey: .underRange)
        try container.encode(aboveRange, forKey: .aboveRange)
        try container.encode(target, forKey: .target)
        try container.encode(abovePattern, forKey: .abovePattern)
        try container.encode(atPattern, forKey: .atPattern)
        try container.encode(underPattern, forKey: .underPattern)
        try container.encode(type, forKey: .type)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(duration)
        hasher.combine(step)
        hasher.combine(startVal)
        hasher.combine(endVal)
        hasher.combine(underRange)
        hasher.combine(aboveRange)
        hasher.combine(target)
        hasher.combine(abovePattern)
        hasher.combine(atPattern)
        hasher.combine(underPattern)
        hasher.combine(type)
    }
    
    init(){
        self.name = "Step"
        self.duration = 3.0
        self.step = 20.0
        self.startVal = 20.0
        self.endVal = 60.0
        self.underRange = 10.0
        self.aboveRange = 10.0
        self.target = 20.0
        self.abovePattern = MadePatternsList.getPatternByName("super pulse")!
        self.atPattern = MadePatternsList.getPatternByName("heartbeat")!
        self.underPattern = MadePatternsList.getPatternByName("short-long")!
        self.type = DataType.rower
    }
    
    func encoder() -> Data{
        let data = try! PropertyListEncoder.init().encode(self)
        print("encoding test...")
        return data
    }
    
    static func decoder(_ data: Data) -> Test {
        print("decoding test...")
        let test:Test?
        
        do{
            test = try PropertyListDecoder.init().decode(Test.self, from: data)
        }catch{
            test = Test()
        }
        return test!
    }
}

class TestList : Identifiable, Codable, ObservableObject{
    static var tests:[String] = ["Step", "Endurance", "Pyramid", "Just Row"]
}
