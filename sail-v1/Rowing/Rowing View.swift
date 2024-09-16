//
//  ContentView.swift
//  v2
//
//  Created by Alice Mao on 2/1/24.
//

import SwiftUI
import CoreData
import Charts

let timeSort = NSSortDescriptor(key: "timestamp", ascending: true)
let starttimeSort = NSSortDescriptor(key: "starttime", ascending: true)

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

func getElapsed(_ dateOne: Date?, _ dateTwo: Date?) -> TimeInterval {
    if(dateOne != nil && dateTwo != nil) {
        return dateOne!.distance(to: dateTwo!)
    }
    return 0;
}

func getActiveTestDuration(_ test: RowingTest?) -> TimeInterval {
    if(test != nil) {
        return getElapsed(test?.starttime, test?.endtime)
    }
    return 0;
}

func formatTime(_ date:Date?) -> String {
    return date?.formatted(date: .numeric, time: .standard) ?? ""
}

struct PulsingCircle: View {
    var isActive: Bool

    var body: some View {
        Circle()
            .fill(!isActive ? Color.green : Color.red)
            .frame(width: 20, height: 20)
            .overlay(
                isActive ?
                    Circle()
                        .stroke(Color.green.opacity(0.3), lineWidth: 8)
                        .scaleEffect(1.3)
                        .opacity(0)
                : nil
            )
    }
}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \RowingTest.starttime, ascending: false)],
        animation: .default)
    private var rowingTests: FetchedResults<RowingTest>
    @State var subjectId: String = "";
    @State var protocolName: String = ""
    @State var activeTest: RowingTest?
    @State var previousTest: RowingTest?
    @State var activeTestTimer: Timer?
    @State var activeInterval: Interval?
    @State var previousInterval: Interval?
    @State var activeIntervalsArray: [Interval] = []
    @State var concept2monitor:PerformanceMonitor?
    @StateObject var fetchData:FetchData = FetchData()
    
   
    
    @State var protocolObj:Protocols = Protocols()
    @State var currPattern:MadePattern = MadePattern()
    @State var previousPattern:MadePattern = MadePattern()
    @ObservedObject var connector = ConnectToWatch.connect
    
    @State var currPower = 0
    
    @State var currProtocol = Protocols()
    
    @State var powerData:Disposable?
    
    private var timerInterval: TimeInterval = 1;

    var hasActiveTest: Bool {
        return activeTest != nil;
    }
    
    var testFormFieldsAreValid: Bool {
        return subjectId.count > 0;
    }
    
    var hasConnectedRower: Bool {
        return concept2monitor != nil;
    }
    
    
    var body: some View {
       NavigationStack {
            List {
                BluetoothView(
                    concept2monitor: $concept2monitor,
                    fetchData: fetchData
                )
                
                TestSetupView(selectProtocol: $protocolObj, connector: connector)
                
                Section(header: Text("Subject ID"))
                {
                    TextField(
                        "Subject ID*",
                        text: $subjectId
                    )
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .disabled(hasActiveTest)
                }
                
                Section(header: Text("Test patterns")) {
                    
                }
                
                TestingCode(protocolObj: $protocolObj, connector: connector, currPattern: $currPattern, previousPattern: $previousPattern)
                
                Section(header: Text("Rower")) {
                    HStack(alignment: .bottom) {
                        // Live Update Rower Data
                        let formattedPower: String = String(fetchData.strokePower ?? 0)
                        let formattedStrokeRate: String = String(fetchData.strokeRate ?? 0)
                        let formattedDistance: String = String(format: "%.1f", fetchData.distance ?? 0.0)
                        
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
                    }
                    .animation(nil)
                }
                .opacity(hasConnectedRower ? 1 : 0.3)
                
                Section(header: Text("Run Test")) {
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
                            .disabled(!hasConnectedRower || !testFormFieldsAreValid)
                            
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
                    .opacity((hasConnectedRower && testFormFieldsAreValid) ? 1 : 0.3)
                    .overlay(content: {
                        if(!testFormFieldsAreValid) {
                            Text("Subject ID required to start test")
                                .foregroundColor(.blue)
                        }
                        else if(!hasConnectedRower) {
                            Text("Connect to Rower")
                                .foregroundColor(.blue)
                        }
                    })
                }
                
                SavedTestsView()
            }
       }
    }
    
    private func attachObservers(){
        powerData = concept2monitor!.strokePower.attach(observer: {
          (currPow:C2Power) -> Void in
            DispatchQueue.global(qos: .background).async {
                DispatchQueue.main.async {
                    currPower = currPow
                    evaluateInterval()
                    if currPattern.name != previousPattern.name {
                        previousPattern = currPattern
                        updateWatch()
                    }
            }
          }
        })
    }
    
    private func toggleTest() {
        debugPrint("Toggle Test");
        if(hasActiveTest) {
            stopTest()
        }
        else {
            startTest()
        }
    }
    
    private func startTest() {
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
        
        activeInterval = newInterval
        if(activeTest != nil) {
            newInterval.parentTest = activeTest
            activeIntervalsArray.append(newInterval)
            previousInterval = activeInterval;
        }
    }
    
    private func stopTest() {
        debugPrint("Stopped Test");
        activeTest?.endtime = Date()
        saveData()
        previousTest = activeTest;
        activeTest = nil;
        
        activeInterval = nil;
        if(activeTestTimer != nil) {
            activeTestTimer?.invalidate()
            activeTestTimer = nil;
        }
        powerData?.dispose()
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
    

    private func updateWatch(){
        print("update watch")
        print(currPattern.animationState)
        connector.sendDataToWatch(sendObject: currPattern)
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

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

