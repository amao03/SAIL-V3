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
    @State private var  bluetoothSuccess = false
    @State private var bluetoothReady = false
    @State var deviceArr:Array<PerformanceMonitor> = []
//    @State var selectedDevice:PerformanceMonitor = PerformanceMonitor(withPeripheral: <#T##CBPeripheral#>)
//    @State var PerformanceMonitorStore = PerformanceMonitorStore()

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
//        selectedDevice = pm
        BluetoothManager.connectPerformanceMonitor(performanceMonitor: pm)
        BluetoothManager.stopScanningForPerformanceMonitors()
        
        
        
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
                            }){
                                Text(device.peripheralName)
                            }
                        }
                    }
                }
                
//                if selectedDevice != nil{
//                    if(selectedDevice!.isConnected){
                        NavigationLink(destination: {
                            Phone_Landing_View(deviceArr: deviceArr)
                        }, label: {
                            Text("SelectPattern")
                        })
//                    }
//                }
                
            }
        }
        .onAppear(perform: attachBluetooth)
    }
}

