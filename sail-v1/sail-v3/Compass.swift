//
//  Compass.swift
//  sail-v1
//
//  Created by Alice Mao on 8/6/24.
//

import Foundation
import Combine
import CoreLocation
import UIKit


class Compass: NSObject, ObservableObject, CLLocationManagerDelegate {
    var objectWillChange = PassthroughSubject<Void, Never>()
    var connector = ConnectToWatch.connect
    
    var altitude: Int = .zero {
        didSet {
            objectWillChange.send()
        }
    }
    
    var direction: Int = .zero {
        didSet {
            objectWillChange.send()
        }
    }
    
    private let locationManager: CLLocationManager
    
    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        
        self.locationManager.delegate = self
        self.setup()
    }
    
    public func setup() {
        print("location setup")
        self.locationManager.requestWhenInUseAuthorization()
        
        print("status \(locationManager.authorizationStatus)")
        
        if CLLocationManager.headingAvailable() {
            print("heading available")
            self.locationManager.startUpdatingLocation()
            self.locationManager.startUpdatingHeading()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.direction = Int(newHeading.magneticHeading)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if let lastLocation = locations.last {
            self.altitude = Int(lastLocation.altitude)
        }
    }
}
