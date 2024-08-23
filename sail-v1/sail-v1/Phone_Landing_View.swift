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
    
    private var typesArr = ["distance", "heartrate", "cycling power", "altitude"]
    
    var body: some View {
        NavigationView{
            Form{
//                Toggle("Phone Haptics", isOn: $hapticsListBool)
                
                Picker("select type", selection: $patternObject.type) {
                    ForEach(DataType.allCases, id: \.self) { currCase in
                        Text(String(describing: currCase))
                    }
                }
                
                HStack{
                    Text("Target")
                    TextField("",value: $patternObject.target, format: .number).multilineTextAlignment(.trailing)
                }
                
                HStack{
                    Text("Range")
                    TextField("",value: $patternObject.range, format: .number).multilineTextAlignment(.trailing)
                }
                
                Section("Under Pattern", content: {
                    NavigationLink(destination: {
                        MadeHapticsSelector(selectedItems: $patternObject.underPattern)
                    }, label: {
                        Text("Select haptics")
                    })
                    Text("**Selected:** \(patternObject.underPattern.name)")
                    Text("**Description:** \(patternObject.underPattern.description)")
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
                
                Section("Above Pattern", content: {
                    NavigationLink(destination: {
                        MadeHapticsSelector(selectedItems: $patternObject.abovePattern)
                    }, label: {
                        Text("Select haptics")
                    })
                    Text("**Selected:** \(patternObject.abovePattern.name)")
                    Text("**Description:** \(patternObject.abovePattern.description)")
                })
                
                Section("Overall Time", content: {
                    HStack{
                        Text("Between each pattern")
                        TextField("",value: $patternObject.timeOverall, format: .number).multilineTextAlignment(.trailing)
                    }
                })
                
                Button(action:{
                    connector.session.sendMessage(["data":patternObject.encoder()], replyHandler: nil) { (error) in
                        print("Error sending message: \(error)")}
//                    connector.sendDataToWatch(sendObject: patternObject)
                    
                }){
                    Text("Send data to Watch")
                }
                
                Text("Your altitude is \(self.compass.altitude) meters")
                    .font(.headline)
                    .padding()
                
                if self.patternObject.type == DataType.altitude{
                    let data:[String:Any] = ["altitude":self.compass.altitude]
                    let _ = connector.session.sendMessage(data, replyHandler: nil)
                }
                
                Text("Your direction is \(self.compass.direction)")
                    .font(.headline)
                    .padding()
                
                if self.patternObject.type == DataType.direction{
                    let data:[String:Any] = ["direction":self.compass.direction]
                    let _ = connector.sendDirection(sendObject: self.compass.direction)
                }
            }
            .navigationTitle("Custom Haptics")
        }.onAppear(perform: connector.activateSession)
    }
}

