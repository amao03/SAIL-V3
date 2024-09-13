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
    @State private var bluetoothReady = false
    @State private var connectedToDevice = false
    @State private var isChoosingDevice = false
    @State private var availablePerformanceMonitors:Array<PerformanceMonitor> = []
    @State private var bluetoothReadyDisposable:Disposable? = nil
    @Binding var concept2monitor:PerformanceMonitor?
    @ObservedObject private var fetchData = FetchData.sharedInstance

    private func scanForDevices(){
        debugPrint("Scanning")
    
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name(rawValue: PerformanceMonitorStoreDidAddItemNotification),
            object: PerformanceMonitorStore.sharedInstance,
            queue: nil) { (notification) -> Void in
                DispatchQueue.global(qos: .background).async {
                    DispatchQueue.main.async {
                        self.availablePerformanceMonitors = Array(PerformanceMonitorStore.sharedInstance.performanceMonitors)
                    }
                }
        }
        
        BluetoothManager.scanForPerformanceMonitors()
    }
    
    private func connectToDevice(pm: PerformanceMonitor){
        print("connect: \(pm)")
        concept2monitor = pm
        BluetoothManager.connectPerformanceMonitor(performanceMonitor: pm)
        BluetoothManager.stopScanningForPerformanceMonitors()
        connectedToDevice = true
        isChoosingDevice = false
    }
    
    var body: some View {
        if(!bluetoothReady) {
            HStack {
                Text("Loading Bluetooth    ")
                ProgressView()
            }
            .onAppear {
                debugPrint("Waiting for Bluetooth")
                bluetoothReadyDisposable = BluetoothManager.isReady.attach{
                    [self] (isReady:Bool) -> Void in
                        print(isReady)
                        self.bluetoothReady = isReady
                }
            }
            .onDisappear {
                debugPrint("Found Bluetooth: Remove")
                bluetoothReadyDisposable?.dispose()
                bluetoothReadyDisposable = nil
                scanForDevices()
            }
        }
        else if(!connectedToDevice) {
            Button("Connect to Rower") {
                isChoosingDevice = true
            }
            .confirmationDialog(
                "Connect to Concept2 Rower",
                isPresented: $isChoosingDevice
            ) {
                ForEach(availablePerformanceMonitors, id: \.self) { device in
                    if (device.peripheralName != "Unknown"){
                        Button(action:{ [self] in
                            connectToDevice(pm: device)
                            concept2monitor = device
                            FetchData.setPerformanceMonitor(device)
                        }){
                            Text(device.peripheralName)
                        }
                    }
                }
            } message: {
                Text("If no rowers found, make sure WiFi is enabled on Concept2")
            }
        }
        else {
            Text("Connect Rower: \(concept2monitor?.peripheralName ?? "")")
        }
    }
}
