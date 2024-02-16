//
//  FetchData.swift
//  v2
//
//  Created by Alice Mao on 2/16/24.
//

import Foundation

class FetchData{
    @Published var concept2monitor:PerformanceMonitor
    var strokesPerMinuteDisposable:Disposable?
    var strokesPerMinuteLabel = 0
    
    init(concept2monitor: PerformanceMonitor, strokesPerMinuteDisposable: Disposable? = nil, strokesPerMinuteLabel: Int = 0) {
        self.concept2monitor = concept2monitor
        self.strokesPerMinuteDisposable = strokesPerMinuteDisposable
        self.strokesPerMinuteLabel = strokesPerMinuteLabel
    }
    
    public func setRower(pm: PerformanceMonitor){
        concept2monitor = pm
    }
    
    
    public func getPower(){
        print("GET POWER")
        print(concept2monitor.peripheralName)
        
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            print("power timer: \(self.concept2monitor.strokePower.value)")
        }
    }
}
