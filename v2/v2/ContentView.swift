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

func getActiveTestDuration(_ test: RowingTest?) -> TimeInterval {
    if(test != nil) {
        return getElapsed(test?.starttime, test?.endtime)
    }
    return 0;
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
    @State var powerDisposable: Disposable?
    
    private var timerInterval: TimeInterval = 1;

    
    var testFormFieldsAreValid: Bool {
        return subjectId.count > 0;
    }
    
    var body: some View {
       NavigationStack {
            List {
                BluetoothView(concept2monitor: $concept2monitor)
                
                TestSetupView(selectProtocol: $protocolObj, connector: connector)
                
//                Section(header: Text("Subject ID"))
//                {
//                    TextField(
//                        "Subject ID*",
//                        text: $subjectId
//                    )
//                    .textInputAutocapitalization(.never)
//                    .disableAutocorrection(true)
//                    .disabled(hasActiveTest)
//                }
                
                Section(header: Text("Test patterns")) {
                    
                }
                
                TestingCode(protocolObj: $protocolObj, connector: connector, currPattern: $currPattern, previousPattern: $previousPattern)
                
                RowingTestView()
                
                SavedTestsView()
            }
       }
    }
    
    private func attachObservers(){
        powerDisposable = concept2monitor!.strokePower.attach(observer: {
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
