//
//  Altitude.swift
//  sail-v1
//
//  Created by Alice Mao on 8/6/24.
//

import Foundation
import SwiftUI
import CoreLocation

struct AltitudeView: View {
    @ObservedObject var compass = Compass()
    
    @State private var altitude: Double = 0.0
    @State private var direction: Double = 0.0
        
    var body: some View {
        VStack {
            Text("Your altitude is \(self.compass.altitude) meters")
                .font(.headline)
                .padding()
            
            Text("Your direction is \(self.compass.direction)")
                .font(.headline)
                .padding()
        }.onAppear(perform: compass.setup)
    }
}
