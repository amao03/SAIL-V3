//
//  TestDetailView.swift
//  v2
//
//  Created by Lucas Drummond on 2/26/24.
//
import SwiftUI
import Charts

struct TestDetailView: View {
    @Binding var activeTest: RowingTest
    @Binding var activeIntervalsArray: [Interval]
    @Binding var activeInterval: Interval
    
    var body: some View {
        Section(header: Text("Run Test")) {
            VStack {
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
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 8, trailing: 0))
                
                Divider()
                
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
                .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                
                Divider()
                
                Chart(activeIntervalsArray) {
                    LineMark(
                        x: .value("Time", $0.timestamp!),
                        y: .value("Power", $0.power)
                    )
                }
                .padding(18)
                
            }
            .listRowBackground(Color.gray)
            .opacity((hasConnectedRower && testFormFieldsAreValid) ? 1 : 0.5)
            .blur(radius: (hasConnectedRower && testFormFieldsAreValid) ? 0 : 2)
            .overlay(content: {
                if(!testFormFieldsAreValid) {
                    Text("Subject ID Required")
                        .bold()
                        .foregroundColor(.white)
                }
                else if(!hasConnectedRower) {
                    Text("Connect to Rower")
                        .bold()
                        .foregroundColor(.white)
                }
            })
        }
    }
}
