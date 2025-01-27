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
    
    private func update(){
        print("updating timer")
//        connector.updating = false
//        Timer.scheduledTimer(withTimeInterval: 3, repeats: false){ timer in
//            connector.updating = false
//            timer.invalidate()
//        }
    }
    
    
    private func printVal(){
        print("reciev: \(connector.receivedInitial)")
    }
    
    var body: some View {
        NavigationView{
            VStack{
                if !connector.receivedInitial{
                    Text("awaiting info from phone")
                } else{
                    ScrollView{
                        VStack{
                            if connector.updating{
//                                let _ = self.update()
//                                let _ = timerObj.startPlaying()
                                Text("updating...")
                            }
                            
                            if connector.stopTest{
                                Text("watch view")
                        
                               
                            } else{
                            
                            ZStack{
                                IndicatorView(animationState: connector.pattern.animationState)
                                
                                if (connector.pattern.animationState == AnimationState.above){
                                    Text("Playing Above")
                                } else if (connector.pattern.animationState == AnimationState.under){
                                    Text("Playing Under")
                                } else {
                                    Text("Playing At")
                                }
                            }
//
                            }
                        }
                    }
                    
                }
            }
        }
    }
}
