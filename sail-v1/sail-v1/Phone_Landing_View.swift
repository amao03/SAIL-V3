//
//  Phone-Landing-Page.swift
//  sail-v1
//
//  Created by Alice Mao on 12/7/23.
//

import Foundation
import SwiftUI

struct Phone_Landing_View : View{
    var connector = ConnectToWatch.connect
    @State var patternObject = Pattern()
    
    @State private var hapticsListBool:Bool = false
    
    @ObservedObject var compass = Compass()
    @State var currPower = 0
    
    @State var concept2monitor:PerformanceMonitor?
    @ObservedObject var fetchData = FetchData()
    var fetching = FetchData.sharedInstance
    @State var powerDisposable: Disposable? = nil
    
    var hasConnectedRower: Bool {
        return concept2monitor != nil;
    }
    
    private func attachObservers(){

        if(hasConnectedRower) {
            
//            self.concept2monitor = concept2monitor
            print("not nill")
            powerDisposable = concept2monitor!.strokePower.attach(observer: {
              (currPow:C2Power) -> Void in
                DispatchQueue.global(qos: .background).async {
                    DispatchQueue.main.async {
                        currPower = currPow
                }
              }
            })
        }
        print("no rower")
        

    }


    var body: some View {
        NavigationView{
            Form{
                Picker("select type", selection: $patternObject.type) {
                    ForEach(DataType.allCases, id: \.self) { currCase in
                        Text(String(describing: currCase))
                    }
                }
               
                if patternObject.type == DataType.rower{
                    BluetoothView(concept2monitor: $concept2monitor)
                }
                
                HStack{
                    Text("Target")
                    TextField("",value: $patternObject.target, format: .number).multilineTextAlignment(.trailing)
                }
                
                HStack{
                    Text("Range")
                    TextField("",value: $patternObject.range, format: .number).multilineTextAlignment(.trailing)
                }
                
                Section("Above Pattern", content: {
                    NavigationLink(destination: {
                        MadeHapticsSelector(selectedItems: $patternObject.abovePattern)
                    }, label: {
                        Text("Select haptics")
                    })
                    Text("**Selected:** \(patternObject.abovePattern.name)")
                    Text("**Description:** \(patternObject.abovePattern.description)")
                })
                
                Section("At Pattern", content: {
                    NavigationLink(destination: {
                        MadeHapticsSelector(selectedItems: $patternObject.atPattern)
                    }, label: {
                        Text("Select haptics")
                    })
                    Text("**Selected:** \(patternObject.atPattern.name)")
                    Text("**Description:** \(patternObject.atPattern.description)")
                })
                
                Section("Under Pattern", content: {
                    NavigationLink(destination: {
                        MadeHapticsSelector(selectedItems: $patternObject.underPattern)
                    }, label: {
                        Text("Select haptics")
                    })
                    Text("**Selected:** \(patternObject.underPattern.name)")
                    Text("**Description:** \(patternObject.underPattern.description)")
                })
                
                Section("Overall Time", content: {
                    HStack{
                        Text("Between each pattern")
                        TextField("",value: $patternObject.timeOverall, format: .number).multilineTextAlignment(.trailing)
                    }
                })
                
                
                if (!hasConnectedRower && patternObject.type == DataType.rower){
                    Text("Connect to Rower")
                }else{
                    Button(action:{
                        connector.sendDataToWatch(sendObject: patternObject)
                    }){
                        Text("Send data to Watch")
                    }
                }
                
                if patternObject.type == DataType.altitude{
                    Text("Your altitude is \(self.compass.altitude)")
                        .font(.headline)
                        .padding()
                    
                    let data:[String:Any] = ["altitude":self.compass.altitude]
                    let _ = connector.session.sendMessage(data, replyHandler: nil)
                }
                
                if patternObject.type == DataType.direction{
                    Text("Your direction is \(self.compass.direction)")
                        .font(.headline)
                        .padding()
                    
                    let _ = connector.sendDirection(sendObject: self.compass.direction)
                }
                
                if (patternObject.type == DataType.rower){
                    Text("Your power is \(fetching.strokePower)")
                        .font(.headline)
                        .padding()
                }
            }
            .navigationTitle("Custom Haptics")
        }.onAppear(perform: connector.activateSession)
    }
    

}


