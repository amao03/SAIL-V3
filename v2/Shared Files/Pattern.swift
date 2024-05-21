//
//  Patterns.swift
//  sail-v1
//
//  Created by Alice Mao on 12/7/23.
//

import Foundation

class Pattern: Codable, ObservableObject, Hashable{
    static func == (lhs: Pattern, rhs: Pattern) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
    var underPattern: MadePattern = MadePatternsList.getPatternByName("super pulse")!
    var atPattern: MadePattern = MadePatternsList.getPatternByName("heartbeat")!
    var abovePattern: MadePattern = MadePatternsList.getPatternByName("short-long")!
    
    var timeOverall: Double = 5.0
    
    var type = "rowing"
    var target: Double = 160.0
    var range: Double = 30.0
    
    var name = "v1"
    
    init() {
 
    }
    
    init(underPattern: MadePattern, atPattern: MadePattern, abovePattern: MadePattern, timeOverall: Double = 5.0, type: String = "rowing", target: Double, range: Double) {
        self.underPattern = underPattern
        self.atPattern = atPattern
        self.abovePattern = abovePattern
        self.timeOverall = timeOverall
        self.type = type
        self.target = target
        self.range = range
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(underPattern)
        hasher.combine(atPattern)
        hasher.combine(abovePattern)
        hasher.combine(timeOverall)
        hasher.combine(type)
        hasher.combine(target)
        hasher.combine(range)
    }
    
    // Form a string of haptic names to be displayed
    func stringifyArr(currPattern: MadePattern) -> String{
        var stringList = ""
        
        for (index, haptic) in currPattern.HapticArray.enumerated(){
            if index == 0{
                stringList = haptic.name
            } else {
                stringList = stringList + ", " + haptic.name
            }
        }
        
        return stringList
    }
    
    // Converts a Pattern to a Data object to be sent to watch
    func encoder() -> Data{
        let data = try! PropertyListEncoder.init().encode(self)
        print("encoding...")
        return data
    }
    
    
    // Converts Data from phone to a Pattern object
    static func decoder(_ data: Data) -> Pattern {
        let pattern = try! PropertyListDecoder.init().decode(Pattern.self, from: data)
        print("decoding...")
        
        return pattern
    }
}
