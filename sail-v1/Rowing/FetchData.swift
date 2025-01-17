//
//  FetchData.swift
//  v2
//
//  Created by Alice Mao on 2/16/24.
//

import Foundation
import Combine

class FetchData: NSObject, ObservableObject {
    public static let sharedInstance = FetchData()
    var objectWillChange = PassthroughSubject<Void, Never>()
    
    var strokePower: Int = .zero {
        didSet {
            objectWillChange.send()
        }
    }
    
    private var concept2monitor:PerformanceMonitor? = nil
    private var strokeRateDisposable:Disposable? = nil
    private var distanceDisposable:Disposable? = nil
    private var strokePowerDisposable:Disposable? = nil
//    @Published var strokePower: C2Power? = nil
    @Published var distance: C2Distance? = nil
    @Published var strokeRate: C2StrokeRate? = nil

   
    override init(){
        super.init()
        self.attachObservers()
    }
    
    
    public func setPerformanceMonitor(_ pm: PerformanceMonitor) {
        concept2monitor = pm
        attachObservers()
    }
    
    private func attachObservers() {
        detachObservers()
    
        strokeRateDisposable = concept2monitor?.strokeRate.attach(observer: {
            [weak self] (strokeRate:C2StrokeRate) -> Void in
            if let weakSelf = self {
                DispatchQueue.global(qos: .background).async {
                    DispatchQueue.main.async {
//                        print("Stroke Rate: \(strokeRate)")
                        weakSelf.strokeRate = strokeRate
                    }
                }
            }
        })
        
        distanceDisposable = concept2monitor?.distance.attach(observer: {
            [weak self] (distance:C2Distance) -> Void in
            if let weakSelf = self {
                DispatchQueue.global(qos: .background).async {
                    DispatchQueue.main.async {
//                        print("Distance: \(distance)")
                        weakSelf.distance = distance
                    }
                }
            }
        })
        
        strokePowerDisposable = concept2monitor?.strokePower.attach(observer: {
            (strokePower:C2Power) -> Void in
//            if let weakSelf = self {
                DispatchQueue.global(qos: .background).async {
                    DispatchQueue.main.async {
                        print("Power: \(strokePower)")
//                        self.connector.sendRower(sendObject: strokePower)
                        self.strokePower = strokePower

//                    }
                }
            }
        })
    }

    private func detachObservers() {
        strokeRateDisposable?.dispose()
        distanceDisposable?.dispose()
        strokePowerDisposable?.dispose()
    }
}
                                                                
