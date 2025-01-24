//
//  RowingTestView.swift
//  v2
//
//  Created by Lucas Drummond on 5/21/24.
//

import SwiftUI
import Charts

struct StartTestView: View {
    @EnvironmentObject var currTest : Test
    @EnvironmentObject var connector: ConnectToWatch
    @ObservedObject var timerObj = StartTestTimers.time

    var hasConnectedRower: Bool = true
    var activeTest: RowingTest?
    var previousTest: RowingTest?
    var activeInterval: Interval?
    var previousInterval: Interval?
    var displayInterval: Interval?
    var strokePower: C2Power?
    var strokeRate: C2StrokeRate?
    var distance: C2Distance?
    var strokeCount: C2StrokeCount?
    @State var activeIntervalsArray: [Interval] = []
    
    var hasActiveTest: Bool {
        return activeTest != nil
    }
    
    var displayTest: RowingTest? {
        return activeTest ?? previousTest
    }
    
    var body: some View {
                    Button(action:{
                        timerObj.startOverallTimer()
                    }){
                        Text("Start test")
                    }
        
                    Button(action:{
                        connector.sendDataToWatch(sendObject: true)
                    }){
                        Text("end test")
                    }
        
        /*
        VStack{
            HStack(alignment: .bottom) {
                let formattedPower: String = String(strokePower ?? 0)
                let formattedStrokeRate: String = String(strokeRate ?? 0)
                let formattedDistance: String = String(format: "%.1f", distance ?? 0.0)
                
                VStack(alignment: .leading) {
                    Text(formattedPower)
                        .font(.system(size: 54))
                    Label("Power", systemImage: "bolt.fill")
                        .labelStyle(.titleAndIcon)
                }
                .fixedSize()
                
                Spacer()
                
                VStack(alignment: .center) {
                    Text(formattedStrokeRate)
                        .font(.system(size: 54))
                    Label("Strokes p/m", systemImage: "staroflife")
                        .labelStyle(.titleAndIcon)
                }
                .fixedSize()
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(formattedDistance)
                        .font(.system(size: 54))
                    Label("Distance", systemImage: "scribble.variable")
                        .labelStyle(.titleAndIcon)
                }
                .fixedSize()
            }.opacity(hasConnectedRower ? 1 : 0.3)
            
            VStack {
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
                    .disabled(!hasConnectedRower)
                    
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
                .animation(nil)
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 8, trailing: 0))
                
                Divider()
                
                Chart(activeIntervalsArray) {
                    LineMark(
                        x: .value("Time", $0.timestamp!),
                        y: .value("Power", $0.power)
                    )
                }
                .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                
            }
            .opacity((hasConnectedRower) ? 1 : 0.3)
            .overlay(content: {
                Text("Connect to Rower")
                    .foregroundColor(.blue)
            })
            
        }.padding(30)
//            .rotationEffect(<#T##Angle#>)*/
        
    }
    
    private func toggleTest() {
        if(hasActiveTest) {
            stopTest()
        }
        else {
            startTest()
        }
    }
    
    private func startTest() {
        debugPrint("Started Test");
    }
    
    private func onTimerTick(timer: Timer) {
        //        addNewInterval()
    }
    
    private func addNewInterval() {
        //        if(concept2monitor == nil) {
        //            return
        //        }
        //        let newInterval = Interval(context: viewContext)
        //
        //        newInterval.timestamp = Date()
        //        newInterval.power = Double(concept2monitor?.strokePower.value ?? 0)
        //        newInterval.distance = Double(concept2monitor?.distance.value ?? 0)
        //        newInterval.strokeRate = Int16(concept2monitor?.strokeRate.value ?? 0)
        //
        //        activeInterval = newInterval
        //        if(activeTest != nil) {
        //            newInterval.parentTest = activeTest
        //            activeIntervalsArray.append(newInterval)
        //            previousInterval = activeInterval;
        //        }
    }
    
    private func stopTest() {
        debugPrint("Stopped Test");
        //        activeTest?.endtime = Date()
        //        saveData()
        //        previousTest = activeTest;
        //        activeTest = nil;
        //
        //        activeInterval = nil;
        //        if(activeTestTimer != nil) {
        //            activeTestTimer?.invalidate()
        //            activeTestTimer = nil;
        //        }
        //        powerDisposable?.dispose()
    }
}
