//
//  Carousel.swift
//  v2-watch Watch App
//
//  Created by Alice Mao on 5/4/24.
//

import Foundation
import SwiftUI

struct CarouselView: View {
    @ObservedObject var underPattern:MadePattern
    @ObservedObject var atPattern:MadePattern
    @ObservedObject var abovePattern:MadePattern
    @State var timer: Timer?
    
    func startTimer(singlePattern: MadePattern ) {
        var index = 0
        let totalDuration  = 6.0
        let startTime = Date()
        
        timer = .scheduledTimer(withTimeInterval: singlePattern.duration, repeats: true) { timer in
            let currentTime = Date()
            let elapsedTime = currentTime.timeIntervalSince(startTime)
            
            //playing haptic pattern for totalDuration seconds when startTimer is called
            if (elapsedTime >= totalDuration) {
                timer.invalidate()
                return
            }
          
            let currHaptic = singlePattern.HapticArray[index % singlePattern.HapticArray.count]
            print("currHaptic: \(singlePattern.name)")
            print("duration: \(singlePattern.duration)")
            Haptics.play(currHaptic: currHaptic)
            index += 1
        }
    }
    
    @State private var currentIndex = 0

    var body: some View {
        VStack(spacing:0){
            TabView(selection:$currentIndex){
                ForEach(AnimationState.allCases,id: \.self){ state in
                    VStack{
                        Text(state.localizedName)
                        IndicatorView(animationState: state)
                            .tag(state)
                        Button(action:{
                            if state.localizedName == "under"{
                                startTimer(singlePattern: underPattern)
                            } else if state.localizedName == "at"{
                                startTimer(singlePattern: atPattern)
                            } else{
                                startTimer(singlePattern: abovePattern)
                            }
                        }){
                            if state.localizedName == "under"{
                                Text(underPattern.name)
                            } else if state.localizedName == "at"{
                                Text(atPattern.name)
                            } else{
                                Text(abovePattern.name)
                            }
                        }
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle())
        }
    }
}
