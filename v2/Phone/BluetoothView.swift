//
//  Bluetooth.swift
//  v2-watch Watch App
//
//  Created by Alice Mao on 2/1/24.
//

import Foundation
import SwiftUI

struct BluetoothView : View{
    @State private var  bluetoothSuccess = false
    @State private var bluetoothReady = false
    @State var deviceArr:Array<PerformanceMonitor> = []
//    @State var selectedDevice:PerformanceMonitor

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
        BluetoothManager.connectPerformanceMonitor(performanceMonitor: pm)
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
//                            self.selectedDevice = device
                            NavigationLink(destination: Phone_Landing_View()){
                                Text(device.peripheralName)
                            }
                        }
                    }
                }
            }
        }
        .onAppear(perform: attachBluetooth)
    }
}

#Preview{
    BluetoothView()
}
