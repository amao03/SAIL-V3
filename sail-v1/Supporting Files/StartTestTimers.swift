//
//  StartTestTimers.swift
//  sail-v3
//
//  Created by Alice Mao on 1/13/25.
//

import Foundation
import SwiftUI
import HealthKit

final class StartTestTimers: NSObject, ObservableObject{
    static let time = StartTestTimers()
    var connector = ConnectToWatch.connect
    let fakeDataArr = [0.0, 1.0, 2.0, 0.0]
    var fakeDataIndex = 0
    @Published var end:Bool = false
    
    @Published var fetchData:FetchData = FetchData()
    @Published var compass:Compass = Compass()
    @Published var currPattern:MadePattern = MadePattern()
    @Published var currentData = 160.0
    
    let test = Test.test
    var updateData: Timer?
    var overallTimer: Timer?
    var counter = 0
    
    public func startOverallTimer(){
        print("start overall timer")
        
        setCurrentValue()
        determinePattern()
        
        //updates value and pattern based on the interval user selects for updateSecs
        updateData = Timer.scheduledTimer(timeInterval: test.updateData, target: self, selector: #selector(updateDataTimer), userInfo: nil, repeats: true)
        
        
        if(test.name == "Step"){
            print("set step timer")
            test.target = test.startVal
            overallTimer = Timer.scheduledTimer(timeInterval: test.stepDuration, target: self, selector: #selector(fireStepTimer), userInfo: nil, repeats: true)
        }
        
        else if(test.name == "Endurance"){
            overallTimer = Timer.scheduledTimer(timeInterval: test.testDuration, target: self, selector: #selector(fireEnduranceTimer), userInfo: nil, repeats: false)
        }
        
        
        //Just row
        if self.end{
            print("done with overall")
            self.end = true
            overallTimer?.invalidate()
            updateData?.invalidate()
            fakeDataIndex = 0
        }

    }
    
    @objc func updateDataTimer(){
        setCurrentValue()
        determinePattern()
        connector.sendDataToWatch(sendObject: currPattern)
        print("updateData")
    }
    
    @objc func fireStepTimer(){
        if(test.target > test.endVal){
            print("done with step timer")
            self.end = true
            overallTimer?.invalidate()
            updateData?.invalidate()
            return
        } else if self.end{
            print("done with overall")
            self.end = true
            overallTimer?.invalidate()
            updateData?.invalidate()
            fakeDataIndex = 0
            return
        }
        print("update Step \(test.target)")
        test.target = test.target + test.step
    }
    
    @objc func fireEnduranceTimer(){
        print("end endurance test")
        updateData?.invalidate()
        overallTimer?.invalidate()
        return
    }

}
