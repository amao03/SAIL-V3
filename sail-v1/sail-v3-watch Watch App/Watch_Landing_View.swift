//
//  Watch_Landing_page.swift
//  sail-v1-watch Watch App
//
//  Created by Alice Mao on 12/8/23.
//

import Foundation
import SwiftUI
import HealthKit
import WatchKit

struct Watch_Landing_View : View {
    @ObservedObject var connector = ConnectToWatch.connect
    @ObservedObject var timerObj = PlayHaptics.time
    
    var body: some View {
        NavigationView{
            VStack{
                if connector.stopTest{
                    Text("awaiting info from phone")
                } else{
                    VStack{
                        IndicatorView(animationState: connector.pattern.animationState)
                        if (connector.pattern.animationState == AnimationState.above){
                            Text("Playing Above")
                        } else if (connector.pattern.animationState == AnimationState.under){
                            Text("Playing Under")
                        } else {
                            Text("Playing At")
                        }
                    }
                }
            }
        }
    }
}
