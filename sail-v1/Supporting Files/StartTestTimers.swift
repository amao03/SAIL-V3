//
//  StartTestTimers.swift
//  sail-v3
//
//  Created by Alice Mao on 1/13/25.
//

import AVFoundation
import Foundation
import HealthKit
import SwiftUI

final class StartTestTimers: NSObject, ObservableObject {
    var audioPlayer: AVAudioPlayer?

    static let time = StartTestTimers()
    var connector = ConnectToWatch.connect
    let fakeDataArr = [0.0, 1.0, 2.0, 0.0]
    var fakeDataIndex = 0
    @Published var end: Bool = false

    @Published var fetchData: FetchData = FetchData()
    @Published var compass: Compass = Compass()
    @Published var currPattern: MadePattern = MadePattern()
    @Published var currentData = 0.0
    @Published var currentSound = ""

    let test = Test.test
    var updateData: Timer?
    var overallTimer: Timer?
    var counter = 0

    public func startOverallTimer() {
        print("start overall timer")

        self.end = false
        setCurrentValue()
        determinePattern()
        playSound()
        connector.sendDataToWatch(sendObject: currPattern)

        //updates value and pattern based on the interval user selects for updateSecs
        updateData = Timer.scheduledTimer(
            timeInterval: test.updateData, target: self,
            selector: #selector(updateDataTimer), userInfo: nil, repeats: true)

        if test.name == "Step" {
            print("set step timer")
            test.target = test.startVal
            overallTimer = Timer.scheduledTimer(
                timeInterval: test.stepDuration, target: self,
                selector: #selector(fireStepTimer), userInfo: nil, repeats: true
            )
        } else if test.name == "Endurance" {
            overallTimer = Timer.scheduledTimer(
                timeInterval: test.testDuration, target: self,
                selector: #selector(fireEnduranceTimer), userInfo: nil,
                repeats: false)
        }

        //Just row
        if self.end {
            print("done with overall")
            endTimers()
        }

    }

    public func endTimers() {
        self.end = true
        overallTimer?.invalidate()
        updateData?.invalidate()
        audioPlayer?.stop()
        audioPlayer = nil
        connector.sendDataToWatch(sendObject: true)
        fakeDataIndex = 0
    }

    @objc func updateDataTimer() {
        setCurrentValue()
        determinePattern()
        playSound()
        connector.sendDataToWatch(sendObject: currPattern)
        print("updateData")
    }

    @objc func fireStepTimer() {
        test.target = test.target + test.step
        print("update Step \(test.target)")

        if test.target > test.endVal {
            test.target = test.endVal
            print("done with step timer")
            endTimers()
            return
        } else if self.end {
            test.target = test.endVal
            print("done with overall")
            endTimers()
            return
        }

    }

    @objc func fireEnduranceTimer() {
        print("end endurance test")
        endTimers()
        return
    }

    func playSound() {
        audioPlayer?.stop()
        audioPlayer = nil

        print("play sound")
        let url = Bundle.main.url(
            forResource: currentSound, withExtension: "mp3")

        audioPlayer = try! AVAudioPlayer(contentsOf: url!)
        audioPlayer?.volume = 1
        audioPlayer?.play()
    }
}
