//
//  Tests.swift
//  SailV3
//
//  Created by Alice Mao on 11/2/24.
//

import Foundation

class Test: Identifiable, ObservableObject{
    static var test:Test = Test()
    
    @Published var name:String
    @Published var subjectID = "0"

    @Published var type = DataType.rower
    
    @Published var abovePattern = MadePatternsList.getPatternByName("super pulse")!
    @Published var atPattern = MadePatternsList.getPatternByName("heartbeat")!
    @Published var underPattern = MadePatternsList.getPatternByName("short-long")!
    
    @Published var aboveSound = "alarm"
    @Published var atSound = "game"
    @Published var underSound = "clock"
    
    
    @Published var underRange = 10.0
    @Published var aboveRange = 10.0
    
    //How frequently data gets updated
    @Published var updateData = 3.0
    
    //endurance variables
    @Published var target = 20.0
    @Published var testDuration = 20.0
    
    //step variables
    @Published var step = 20.0
    @Published var startVal = 20.0
    @Published var endVal = 60.0
    @Published var stepDuration = 5.0
   
    init(){
        self.name = "Step"
        self.subjectID = "0"
        self.updateData = 3.0
        self.underRange = 10.0
        self.aboveRange = 10.0
        self.abovePattern = MadePatternsList.getPatternByName("super pulse")!
        self.atPattern = MadePatternsList.getPatternByName("heartbeat")!
        self.underPattern = MadePatternsList.getPatternByName("short-long")!
        
        self.aboveSound = "FREQ_HIGH"
        self.atSound = "FREQ_MID"
        self.underSound = "FREQ_LOW"
        
        self.type = DataType.rower
        
        //endurance
        self.target = 20.0
        self.testDuration = 20.0
        
        //step
        self.step = 20.0
        self.startVal = 20.0
        self.endVal = 60.0
        self.stepDuration = 5.0
    }
}

extension Test: Hashable {
    static func == (lhs: Test, rhs: Test) -> Bool {
        return lhs.name == rhs.name
    }
    
    public func hash(into hasher: inout Hasher) {
             hasher.combine(ObjectIdentifier(self))
        }
}

class TestList : Identifiable, Codable, ObservableObject{
    static var tests:[String] = ["Step", "Endurance", "Pyramid", "Just Row"]
}
