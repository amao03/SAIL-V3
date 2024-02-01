//
//  Watch_Landing_page.swift
//  sail-v1-watch Watch App
//
//  Created by Alice Mao on 12/8/23.
//

import Foundation
import SwiftUI
import HealthKit

struct Watch_Landing_View : View {
    @ObservedObject var connector = ConnectToWatch.connect
    @ObservedObject var timerObj = TimerControls.time
    @State private var authorize: Bool = false
    @State private var realData:Bool = false
    @State private var randomData:Bool = false
    
   private var backgroundColor = Color.black

    private func update(){
        print("updating timer")
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false){ timer in
                ConnectToWatch.connect.updating = false
                timer.invalidate()
        }
    }
    
    var body: some View {
        NavigationView{
            VStack{
                if authorize{
                    if ConnectToWatch.connect.receivedInitial{
                        ScrollView{
                            VStack{
                                if ConnectToWatch.connect.updating{
                                    let _ = self.update()
                                    Text("updating...")
                                }
                                Toggle("Real data", isOn: $realData)
                                Toggle("Random data", isOn: $randomData)
                                if timerObj.end{
                                    Button(action:{
                                        print("starting....")
                                        timerObj.toggleEnd()
                                        timerObj.setPattern(pattern: connector.pattern)
                                        timerObj.overallTimer(realData: realData, randomData: randomData)
                                    }){
                                        Text("Start")
                                    }
                                }
                                else{
                                    Button(action:{
                                        timerObj.toggleEnd()
                                        print("stopping")
                                    }){
                                        Text(timerObj.patternObject.type)
                                        Text("stop")
                                    }
                                }
                                
                                NavigationLink(destination: DisplayInfo(currPattern: $connector.pattern)){
                                    Text("View Patterns")
                                }
                                
                                Text("currData: \(timerObj.currentData, specifier: "%.2f")")
//                                let _ = updateColor()
                            }
                        }
                        .background(backgroundColor)
                    }
                    else{
                        Text("awaiting info from phone")
                    }
                }
                else {
                    Text("need to authorize")
                }
            }
        }
      
    }
}
