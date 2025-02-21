//
//  RowingTestView.swift
//  v2
//
//  Created by Alice Mao on 5/21/24.
//

import SwiftUI
import Charts

struct StartTestView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @EnvironmentObject var currTest : Test
    @ObservedObject var timerObj = StartTestTimers.time
    @ObservedObject var fetching = FetchData.sharedInstance
    @ObservedObject var compass = Compass()
    
    @State var isTestRunning = false

    var hasConnectedRower: Bool = true
    @State var activeTest: RowingTest?
    @State var previousTest: RowingTest?
    @State var activeInterval: Interval?
    @State var previousInterval: Interval?
    @State var displayInterval: Interval?
    @State var activeTestTimer: Timer?
    @State var strokePower: C2Power?
    @State var strokeRate: C2StrokeRate?
    @State var distance: C2Distance?
    @State var strokeCount: C2StrokeCount?
    @State var concept2monitor:PerformanceMonitor?
    @State var activeIntervalsArray: [Interval] = []
    
    var hasActiveTest: Bool {
        return activeTest != nil
    }
    
    var displayTest: RowingTest? {
        return activeTest ?? previousTest
    }
    
    
    var body: some View {
        VStack{
            VStack{
                HStack(alignment: .bottom) {
                    let formattedPower:String = String(timerObj.currentData)
                    let formattedTarget:String = String(currTest.target)
                    
                    VStack(alignment: .center) {
                        Text(formattedPower)
                            .font(.system(size: 54))
                        Label("Power", systemImage: "bolt.fill")
                            .labelStyle(.titleAndIcon)
                    }
                    .fixedSize()
                    
                    Spacer()
                    
                    VStack(alignment: .center) {
                        Text(formattedTarget)
                            .font(.system(size: 54))
                        Text("Target")
                    }
                    .fixedSize()
                }
                
                VStack {
                    let displayTest = activeTest ?? previousTest
                    let displayInterval = activeInterval ?? previousInterval
                    
                    let curDurationInterval: TimeInterval = getElapsed(displayTest?.starttime, displayInterval?.timestamp)
                    let curDuration: String = Duration(
                        secondsComponent: Int64(curDurationInterval),
                        attosecondsComponent: 0
                    ).formatted(.time(pattern: .minuteSecond))
                    
                    HStack {
                        Button(action: toggleTest) {
                            Text(hasActiveTest ? "Stop Test" : "Start Test")
                        }
                        .font(.system(size: 24))
                        .buttonStyle(.bordered)
                        
                        PulsingCircle(isActive: hasActiveTest)
                            .frame(width: 40, height: 40, alignment: .trailing)
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("\(curDuration)")
                                .font(.system(size: 36))
                            
                            Label("Duration", systemImage: "clock.fill")
                                .labelStyle(.titleOnly)
                                .font(.system(size: 12))
                        }
                    }
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 8, trailing: 0))
                    
                    Divider()
                    
                    Chart(activeIntervalsArray) {
                        LineMark(
                            x: .value("Time", $0.timestamp!),
                            y: .value("Power", $0.target)
                        ).foregroundStyle(.blue) // First line (actual values)
                        
                        LineMark(
                            x: .value("Time", $0.timestamp!),
                            y: .value("Target", $0.target)
                        )
                        .foregroundStyle(.red)
                    }.chartXAxis {
                        AxisMarks()
                    }
                    .chartYAxis {
                        AxisMarks()
                    }
                    .frame(height: 300)
                    .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                    
                }
            }.padding(30)
        }
    }
    
    private func toggleTest() {
        print("toggle test")
        if(hasActiveTest) {
            stopTest()
        }
        else {
            startTest()
        }
    }
    
    private func startTest() {
        debugPrint("Started Test");
        
        let newRowingTest = RowingTest(context: viewContext)
        newRowingTest.starttime = Date()
        newRowingTest.testName = currTest.name
        newRowingTest.subjectId = currTest.subjectID
        activeTest = newRowingTest
        
        activeTestTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: onTimerTick)
        
        addNewInterval()
        
        timerObj.startOverallTimer()
    }
    
    private func onTimerTick(timer: Timer) {
        if timerObj.end{
            stopTest()
        } else{
            addNewInterval()
        }
    }
    
    private func addNewInterval() {
                let newInterval = Interval(context: viewContext)
        
                newInterval.timestamp = Date()
                newInterval.value = Double(concept2monitor?.strokePower.value ?? 0)
                newInterval.target = Double(concept2monitor?.distance.value ?? 0)
        
                activeInterval = newInterval
                if(activeTest != nil) {
                    newInterval.parentTest = activeTest
                    activeIntervalsArray.append(newInterval)
           
//                    previousInterval = activeInterval;
                }
    }
    
    public func stopTest() {
        debugPrint("Stopped Test");
        timerObj.endTimers()
        activeTest?.endtime = Date()
        saveData()
        //        previousTest = activeTest;
        activeTest = nil;
        //
                activeInterval = nil;
                    activeTestTimer?.invalidate()
                    activeTestTimer = nil;
        activeIntervalsArray = []
        //        powerDisposable?.dispose()
    }
    
    private func saveData() {
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
   
}
