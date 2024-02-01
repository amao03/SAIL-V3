//
//  Patterns.swift
//  sail-v1
//
//  Created by Alice Mao on 12/7/23.
//

import Foundation

struct Pattern: Hashable, Codable{
    var underPattern: MadePattern = MadePattern()
    var atPattern: MadePattern = MadePattern()
    var abovePattern: MadePattern = MadePattern()
    
    var underTime: Double = 0.5
    var atTime: Double = 0.5
    var aboveTime: Double = 0.5
    var timeOverall: Double = 5.0
    
    var type = "rowing"
    var target: Double = 160.0
    var range: Double = 30.0
    
    
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


