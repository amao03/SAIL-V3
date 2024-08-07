//
//  Timer_Controls.swift
//  sail-v1
//
//  Created by Alice Mao on 12/8/23.
//

import Foundation
import HealthKit
import SwiftUI

class TimerControls: NSObject, ObservableObject{
    static let time = TimerControls()
    var connector = ConnectToWatch.connect
    let fakeDataArr = [150.0, 160.0, 170.0, 150.0]
    var fakeDataIndex = 0
    
    @Published var end:Bool = true
    @Published var currentData = 160.0
    @Published var currPattern:[Haptics] = []
    @Published var timeBetween = 1.0
    var currPatternIndex = 0
    
    @ObservedObject var ExtendedSess = ExtendedSession()
    
    var overallTimer: Timer?
    var currentTimer: Timer?
    var startTime = Double(DispatchTime.now().uptimeNanoseconds)
    
    // Deals with stopping timer early and displaying start/stop button
    public func toggleEnd(){
        print("toggle end \(end)")
        self.end = !end
    }

    // Controls the overall timing of playing haptics
    public func startOverallTimer(){
        ExtendedSess.startExtendedSession()
        print("start overall timer")
        
        setCurrentValue()
        setCurrentPattern()
        
        overallTimer = Timer.scheduledTimer(timeInterval: connector.pattern.timeOverall, target: self, selector: #selector(fireOverallTimer), userInfo: nil, repeats: true)
    }
    
    // Plays a specific haptic pattern for a given amount of time
    func startCurrentTimer(){
        if currPattern.count == 0{
            Timer.scheduledTimer(withTimeInterval: connector.pattern.timeOverall, repeats: false) { timer in
            }
            return
        }
        
        currentTimer = Timer.scheduledTimer(timeInterval: timeBetween, target: self, selector: #selector(fireCurrentTimer), userInfo: nil, repeats: true)
    }
    
    @objc func fireOverallTimer(){
        setCurrentValue()
        setCurrentPattern()
        startCurrentTimer()
        
        if (self.connector.pattern.type == DataType.fake && fakeDataIndex >= 4){
            print("done with overall")
            overallTimer?.invalidate()
            self.ExtendedSess.stopExtendedSession()
            self.end = true
            return
        } else if self.end{
            print("done with overall")
            self.ExtendedSess.stopExtendedSession()
            self.end = true
            overallTimer?.invalidate()
            return
        }
    }
    
    @objc func fireCurrentTimer(){
        let elapsedTime = Double(DispatchTime.now().uptimeNanoseconds) - startTime
        
        if elapsedTime >= self.connector.pattern.timeOverall {
            currentTimer?.invalidate()
            currPatternIndex = 0
            return
        } else if self.end{
            currentTimer?.invalidate()
            self.end = true
            currPatternIndex = 0
            return
        }
        
        let currHaptic = currPattern[currPatternIndex % currPattern.count]
        Haptics.play(currHaptic: currHaptic)
        currPatternIndex += 1
    }
}
