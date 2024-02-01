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
    
    var body: some View {
        NavigationStack{
            Button(action:{
                bluetoothSuccess = true;
                print(bluetoothSuccess)
            }){
                Text("Find Device")
            }
        
            .navigationDestination(isPresented: $bluetoothSuccess) {
                Phone_Landing_View()
            }
           
        }
    }
}

#Preview{
    BluetoothView()
}
