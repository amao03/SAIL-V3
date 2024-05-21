//
//  FetchData.swift
//  v2
//
//  Created by Alice Mao on 2/16/24.
//

import Foundation

public final class FetchData: ObservableObject {
    
    public static let sharedInstance = FetchData()

    @Published var concept2monitor:PerformanceMonitor? = nil
    private var strokeRateDisposable:Disposable? = nil
    private var distanceDisposable:Disposable? = nil
    private var strokePowerDisposable:Disposable? = nil
    private var strokeCountDisposable:Disposable? = nil
    @Published var strokePower: C2Power? = nil
    @Published var distance: C2Distance? = nil
    @Published var strokeRate: C2StrokeRate? = nil
    @Published var strokeCount: C2StrokeCount? = nil
    @Published var activeTest: RowingTest?
    @Published var previousTest: RowingTest?
    private var activeInterval: Interval?
    private var previousInterval: Interval?
    private var activeIntervalsArray: [Interval] = []
    private var activeTestTimer: Timer?
    private var timerInterval: TimeInterval = 1;
    
    init(concept2monitor: PerformanceMonitor? = nil) {
        if(concept2monitor != nil) {
            self.concept2monitor = concept2monitor
            attachRowerDataObservers()
        }
    }
    
    public static func setPerformanceMonitor(_ pm: PerformanceMonitor) {
        sharedInstance.concept2monitor = pm
        sharedInstance.attachRowerDataObservers()
    }
    
    var hasActiveTest: Bool {
        return activeTest != nil;
    }
    
    var hasConnectedRower: Bool {
        return concept2monitor != nil;
    }
    
    private func attachRowerDataObservers() {
        detachRowerDataObservers()
    
        strokeRateDisposable = concept2monitor?.strokeRate.attach(observer: {
            [weak self] (strokeRate:C2StrokeRate) -> Void in
            if let weakSelf = self {
                DispatchQueue.global(qos: .background).async {
                    DispatchQueue.main.async {
                        weakSelf.strokeRate = strokeRate
                    }
                }
            }
        })
        
        distanceDisposable = concept2monitor?.distance.attach(observer: {
            [weak self] (distance:C2Distance) -> Void in
            if let weakSelf = self {
                DispatchQueue.global(qos: .background).async {
                    DispatchQueue.main.async {
                        weakSelf.distance = distance
                    }
                }
            }
        })
        
        strokePowerDisposable = concept2monitor?.strokePower.attach(observer: {
            [weak self] (strokePower:C2Power) -> Void in
            if let weakSelf = self {
                DispatchQueue.global(qos: .background).async {
                    DispatchQueue.main.async {
                        print("Power: \(strokePower)")
                        weakSelf.strokePower = strokePower
                    }
                }
            }
        })
        
        strokeCountDisposable = concept2monitor?.strokeCount.attach(observer: {
            [weak self] (strokeCount:C2StrokeCount) -> Void in
            if let weakSelf = self {
                DispatchQueue.global(qos: .background).async {
                    DispatchQueue.main.async {
                        weakSelf.strokeCount = strokeCount
                    }
                }
            }
        })
    }
    
    private func detachRowerDataObservers() {
        strokeRateDisposable?.dispose()
        distanceDisposable?.dispose()
        strokePowerDisposable?.dispose()
        strokeCountDisposable?.dispose()
    }
    
    private func toggleRowingTest() {
        debugPrint("Toggle Test");
        if(hasActiveTest) {
            stopTest()
        }
        else {
            startTest()
        }
    }
    
    private func startRowingTest() {
        debugPrint("Started Test");
        activeIntervalsArray = []
        let newRowingTest = RowingTest(context: viewContext)
        newRowingTest.starttime = Date()
        newRowingTest.protocolName = protocolObj.name
        newRowingTest.subjectId = subjectId
        activeTest = newRowingTest
        attachObservers()
        activeTestTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: onTimerTick)
        addNewInterval()
    }
    
    private func onTimerTick(timer: Timer) {
        addNewInterval()
    }
    
    private func addNewInterval() {
        if(concept2monitor == nil) {
            return
        }
        let newInterval = Interval(context: viewContext)
        
        newInterval.timestamp = Date()
        newInterval.power = Double(concept2monitor?.strokePower.value ?? 0)
        newInterval.distance = Double(concept2monitor?.distance.value ?? 0)
        newInterval.strokeRate = Int16(concept2monitor?.strokeRate.value ?? 0)
        
        activeInterval = newInterval
        if(activeTest != nil) {
            newInterval.parentTest = activeTest
            activeIntervalsArray.append(newInterval)
            previousInterval = activeInterval;
        }
    }
    
    private func stopRowingTest() {
        debugPrint("Stopped Test");
        activeTest?.endtime = Date()
//        saveData()
        previousTest = activeTest;
        activeTest = nil;
        
        activeInterval = nil;
        if(activeTestTimer != nil) {
            activeTestTimer?.invalidate()
            activeTestTimer = nil;
        }
        powerDisposable?.dispose()
    }
    
    private func evaluateInterval(){
        if currPower < Int(protocolObj.pattern.target - protocolObj.pattern.range) {
            print("under")
            currPattern = protocolObj.pattern.underPattern
            currPattern.animationState = AnimationState.under
        }
        else if currPower > Int(protocolObj.pattern.target + protocolObj.pattern.range) {
            print("above")
            currPattern = protocolObj.pattern.abovePattern
            currPattern.animationState = AnimationState.above
        } else{
            print("at")
            currPattern = protocolObj.pattern.atPattern
            currPattern.animationState = AnimationState.at
        }
    }
}
