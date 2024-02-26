//
//  ContentView.swift
//  v2
//
//  Created by Alice Mao on 2/1/24.
//

import SwiftUI
import CoreData
import Charts

enum ProtocolNames: String, CaseIterable, Identifiable {
    case V1 = "V1", V2 = "V2", V3 = "V3"
    var id: Self { self }
}

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

struct SavedTestsListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \RowingTest.starttime, ascending: false)],
        animation: .default)
    private var rowingTests: FetchedResults<RowingTest>

    var body: some View {
        List {
            Section(header: Text("Previous Tests")) {
                ForEach(rowingTests) { rowingTest in
                    NavigationLink {
                        SavedTestDetailView(rowingTest: rowingTest)
                    } label: {
                        Text(formatTime(rowingTest.starttime))
                    }
                }
                .onDelete(perform: deleteItems)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { rowingTests[$0] }.forEach(viewContext.delete)

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
}

struct SavedTestDetailView: View {
    var rowingTest: RowingTest
    var intervals: [Interval]?
    
    init(rowingTest: RowingTest) {
        self.rowingTest = rowingTest
        self.intervals = rowingTest.intervals?.sortedArray(using: [timeSort]) as? [Interval]
        debugPrint(self.intervals as Any)
    }

    var body: some View {
        let formattedStarttime = formatTime(rowingTest.starttime);
        let duration = getActiveTestDuration(rowingTest);
        
        Text("Test")
            .font(.largeTitle)
        List {
            Text("Start: \(formattedStarttime)")
            Text("Duration: \(duration)")
            Text("Subject Id: \(rowingTest.subjectId ?? "")")
            Text("Protocol Name: \(rowingTest.protocolName ?? "")")
        }

        if(intervals != nil) {
            Chart(intervals!) {
                LineMark(
                    x: .value("Time", $0.timestamp!),
                    y: .value("Power", $0.power)
                )
            }
            .padding(20)
        }
    }
}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \RowingTest.starttime, ascending: false)],
        animation: .default)
    private var rowingTests: FetchedResults<RowingTest>
    @State var activeTest: RowingTest?
    @State var subjectId: String = "";
    @State var protocolName: ProtocolNames = ProtocolNames.V1
    @State var activeTestTimer: Timer?
    @State var activeInterval: Interval?
    @State var activeIntervalsArray: [Interval] = []
    @State var connectedRower: String?

    private var timerInterval: TimeInterval = 1;

    var hasActiveTest: Bool {
        return activeTest != nil;
    }
    
    var testFormFieldsAreValid: Bool {
        return subjectId.count > 0;
    }
    
    var hasConnectedRower: Bool {
        return connectedRower != nil;
    }
    
    func connectToRower() {
        connectedRower = "Concept2 #5";
    }
    
    var body: some View {
        NavigationStack {
            List {
                if(!hasConnectedRower) {
                    Button(action: connectToRower) {
                        Text("Connect to Rower")
                    }
                }
                else {
                    Text("Connected Rower: \(connectedRower ?? "")")
                }
                
                Section(header: Text("Test Setup") ) {
                    TextField(
                        "Subject ID*",
                        text: $subjectId
                    )
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .disabled(hasActiveTest)
                    
                    Picker("Protocol:", selection: $protocolName) {
                        ForEach(ProtocolNames.allCases) { name in
                            Text(name.rawValue.capitalized)
                        }
                    }
                    .disabled(hasActiveTest)
                    
                    NavigationLink {
                        Text("Watch Haptics View")
                    } label: {
                        Text("Watch Haptics")
                    }

                }
                .opacity((hasConnectedRower && !hasActiveTest) ? 1 : 0.5)
                
                Section(header: Text("Run Test")) {
                    HStack {
                        Button(action: toggleTest) {
                            Text(hasActiveTest ? "Stop Test" : "Start Test")
                        }
                        .font(.system(size: 22))
                        .buttonStyle(.bordered)
                        .disabled(!hasConnectedRower || !testFormFieldsAreValid)
                        
                        Spacer()
                        
                        PulsingCircle(isActive: hasActiveTest)
                            .frame(width: 40, height: 40, alignment: .trailing)
                        
                    }
                    
                    let curPower: String = String(format: "%.1f", activeInterval?.power ?? 00.0)
                    let curDurationInterval: TimeInterval = getElapsed(activeTest?.starttime, activeInterval?.timestamp)
                    let curDuration: String = Duration(
                        secondsComponent: Int64(curDurationInterval),
                        attosecondsComponent: 0
                    ).formatted(.time(pattern: .minuteSecond))
                    
                    HStack(alignment: .bottom) {
                        VStack(alignment: .leading) {
                            Text(curPower)
                                .font(.system(size: 60))
                            Label("Power", systemImage: "bolt.fill")
                                .labelStyle(.titleAndIcon)
                        }
                        .fixedSize()

                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text(curDuration)
                                .font(.system(size: 42))

                            Label("Duration", systemImage: "clock.fill")
                                .labelStyle(.titleAndIcon)
                        }
                    }
                    .animation(nil)
                    
                    Chart(activeIntervalsArray) {
                        LineMark(
                            x: .value("Time", $0.timestamp!),
                            y: .value("Power", $0.power)
                        )
                    }
                    .padding(18)
                    
                }
                .opacity((hasConnectedRower && testFormFieldsAreValid) ? 1 : 0.5)
                
                Section(header: Text("Previous Tests")) {
                    NavigationLink {
                        SavedTestsListView()
                    } label: {
                        Text("All Previous Tests (\(rowingTests.count))");
                    }
                }
            }
        }
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
        activeIntervalsArray = []
        debugPrint("Started Test");
        let newRowingTest = RowingTest(context: viewContext)
        newRowingTest.starttime = Date()
        newRowingTest.protocolName = protocolName.rawValue
        newRowingTest.subjectId = subjectId
        activeTest = newRowingTest
        activeTestTimer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true, block: onTimerInterval)
        addNewInterval()
    }
    
    private func onTimerInterval(timer: Timer) {
        debugPrint("Added Interval");
        addNewInterval()
    }
    
    private func addNewInterval() {
        let newInterval = Interval(context: viewContext)
        newInterval.timestamp = Date()
        newInterval.power = Double.random(in: 0..<200)
        activeInterval = newInterval
        if(activeTest != nil) {
            newInterval.parentTest = activeTest
            activeIntervalsArray.append(newInterval)
        }
    }
    
    private func stopTest() {
        debugPrint("Stopped Test");
        activeTest?.endtime = Date()
        saveData()
        activeTest = nil;
        activeInterval = nil; 
        if(activeTestTimer != nil) {
            activeTestTimer?.invalidate()
            activeTestTimer = nil;
        }
    }

    private func saveData() {
        withAnimation {
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
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
