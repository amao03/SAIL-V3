//
//  Made_Patterns.swift
//  sail-v1
//
//  Created by Alice Mao on 12/7/23.
//

import Foundation
import SwiftUI

enum AnimationState: Int, Codable {
    case below, at, above, null
}

class MadePattern: Identifiable, Codable, ObservableObject, Hashable{
    static func == (lhs: MadePattern, rhs: MadePattern) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
    var name: String = "empty"
    var id: String { name }
    var HapticArray: [Haptics] = []
    var duration: Double = 0.5
    var description:String = ""
    var animationState: AnimationState
    
    init() {
        self.name = ""
        self.HapticArray = []
        self.duration = 0.5
        self.description = ""
        self.animationState = AnimationState.at
    }
    
    init(name: String, HapticArray: [Haptics], duration: Double, description: String) {
        self.name = name
        self.HapticArray = HapticArray
        self.duration = duration
        self.description = description
        self.animationState = AnimationState.at
    }
    
    func setAnimationState(animationState: AnimationState){
        self.animationState = animationState
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(HapticArray)
        hasher.combine(duration)
        hasher.combine(description)
    }

    // Converts a Pattern to a Data object to be sent to watch
    func encoder() -> Data{
        let data = try! PropertyListEncoder.init().encode(self)
        print("encoding...")
        return data
    }
    
    
    // Converts Data from phone to a Pattern object
    static func decoder(_ data: Data) -> MadePattern {
        print("decoding...")
        let pattern:MadePattern?
        
        do{
            pattern = try PropertyListDecoder.init().decode(MadePattern.self, from: data)
        }catch{
            pattern = MadePatternsList.getPatternByName("ERROR")
        }
        return pattern!
    }
}

class MadePatternsList: Identifiable, Codable, ObservableObject{
    static var madePatternsList:[MadePattern] = [
        MadePattern(name: "short-long", HapticArray: [Haptics(name: "notification", type: "watch")], duration: 0.5,
                    description: "-  ———  -  ———  -"),
        MadePattern(name:"short-short-long", HapticArray: [Haptics(name: "notification", type: "watch"), Haptics(name: "directionUp", type: "watch")], duration: 0.3,
                    description: "- -  ———  - -  ———"),
        MadePattern(name:"heartbeat", HapticArray: [Haptics(name: "directionUp", type: "watch")], duration: 0.5,
                    description: "--       --       --        --"),
        MadePattern(name:"long heartbeat", HapticArray: [Haptics(name: "directionUp", type: "watch")], duration: 1,
                    description: "--       --       --        --"),
        MadePattern(name:"pulse", HapticArray: [Haptics(name: "directionUp", type: "watch")], duration: 0.1,
                    description: "-  -  -  -  -  -  -  -  -  -  - "),
        MadePattern(name:"long pulse", HapticArray: [Haptics(name: "directionUp", type: "watch")], duration: 0.3,
                    description: "-    -    -    -    -    -    -    - "),
        MadePattern(name:"super pulse", HapticArray: [Haptics(name: "directionUp", type: "watch")], duration: 0.01,
                    description: "-----------------------"),
        MadePattern(name:"ERROR", HapticArray: [], duration:0, description: "ERROR")
    ]
    
    static func getPatternByName(_ name: String) -> MadePattern? {
        return madePatternsList.first(where: {$0.name == name});
    }
}

