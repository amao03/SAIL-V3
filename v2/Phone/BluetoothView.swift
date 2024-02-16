//
//  Bluetooth.swift
//  v2-watch Watch App
//
//  Created by Alice Mao on 2/1/24.
//

import Foundation
import SwiftUI
import CoreBluetooth

struct BluetoothView : View{
    
    @State var concept2monitor:PerformanceMonitor?
    @State private var  bluetoothSuccess = false
    @State private var bluetoothReady = false
    @State private var connectedToDevice = false
    @State var deviceArr:Array<PerformanceMonitor> = []
    
    @State var fetchData:FetchData?

    private func attachBluetooth(){
        bluetoothReady = BluetoothManager.isReady.value
    }
    
    private func scanForDevices(){
        bluetoothSuccess = true;
        print(bluetoothSuccess)
        BluetoothManager.scanForPerformanceMonitors()
        
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name(rawValue: PerformanceMonitorStoreDidAddItemNotification),
            object: PerformanceMonitorStore.sharedInstance,
            queue: nil) { (notification) -> Void in
                DispatchQueue.global(qos: .background).async {
                    DispatchQueue.main.async {
                        deviceArr = Array(PerformanceMonitorStore.sharedInstance.performanceMonitors)
                    }
                }
        }
    }
    
    private func connectToDevice(pm: PerformanceMonitor){
        print("connect: \(pm)")
        concept2monitor = pm
        BluetoothManager.connectPerformanceMonitor(performanceMonitor: pm)
        BluetoothManager.stopScanningForPerformanceMonitors()
        connectedToDevice = true
    }
    
    var body: some View {
        VStack{
            NavigationStack{
                Button(action:scanForDevices){
                    Text("Find Device")
                }
                
                ScrollView{
                    ForEach(deviceArr, id: \.self) { device in
                        if (device.peripheralName != "Unknown"){
                            Button(action:{
                                connectToDevice(pm: device)
                                concept2monitor = device
                                fetchData = FetchData(concept2monitor: device)
                            }){
                                Text(device.peripheralName)
                            }
                        }
                    }
                }
                
                if connectedToDevice{
                    NavigationLink(destination: {
                        Phone_Landing_View(pm: fetchData!)
                        }, label: {
                        Text("SelectPattern")
                    })
                }
                
            }.onAppear(perform: attachBluetooth)
        }
  
    }
}

