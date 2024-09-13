//
//  RandomDataView.swift
//  v2
//
//  Created by Alice Mao on 8/2/24.
//

import Foundation
import SwiftUI

struct RandomDataView: View {
    @Binding var protocolObj:Protocols
    @ObservedObject var connector:ConnectToWatch
    var dataArr = [0, 1, 2, 0]
    @Binding var currPattern:MadePattern
    @Binding var previousPattern:MadePattern
    @State var value = Int.random(in: 0..<3)
    
//    var animationState: AnimationState
    @State private var animationAmount = 1.0;
    @State private var animationDuration = 1.0;
    
    @State private var runRandom = false
    
    
    var body: some View {
        if runRandom{
            HStack{
                Button(action:{
                    runRandom = !runRandom
                }){
                    Text("End")
                }
                Spacer()
                ZStack{
                    Circle()
                        .foregroundColor(getColor(currPattern.animationState))
                        .frame(width: 80, height: 80)
                        .scaleEffect(animationAmount)
                        .animation(
                            .easeInOut(duration: animationDuration)
                            .repeatForever(autoreverses: true),
                            value: animationAmount
                        )
                        .onChange(of: currPattern.animationState) {
                            switch(currPattern.animationState) {
                            case .above:
                                animationAmount = 0.8
                                animationDuration = 2.0
                            case .at:
                                animationAmount = 1.0
                                animationDuration = 1.0
                            case .under:
                                animationAmount = 1.0
                                animationDuration = 0.5
                            }
                        }
                        .onAppear {
                            animationAmount = 1.2;
                        }
                    
                    Text("\(value)")
                }
            }
        } else{
            Button(action:{
                
                value = Int.random(in: 0..<3)
                print("random: \(value)")
                runRandom = !runRandom
                evaluateIntervalFakeData()
                if currPattern.id != previousPattern.id {
                    previousPattern = currPattern
                    connector.sendDataToWatch(sendObject: currPattern)
                }
                
                Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
                    
                    if !runRandom{
                        timer.invalidate()
                        connector.sendDataToWatch(sendObject: MadePatternsList.getPatternByName("END")!)
                        print("ending random data")
                        return
                    }
                    
                    value = Int.random(in: 0..<3)
                    print("random: \(value)")
                    
                    evaluateIntervalFakeData()
                    if currPattern.id != previousPattern.id {
                        previousPattern = currPattern
                        connector.sendDataToWatch(sendObject: currPattern)
                    }
                }
            }){
                Text("Send random data to Watch")
            }
        }
    }
    
    
    private func evaluateIntervalFakeData(){
        if value == 0{
            currPattern = protocolObj.pattern.underPattern
            currPattern.animationState = AnimationState.under
        }
        else if value == 2{
            currPattern = protocolObj.pattern.abovePattern
            currPattern.animationState = AnimationState.above
        } else{
            currPattern = protocolObj.pattern.atPattern
            currPattern.animationState = AnimationState.at
        }
//        print("VAL: \(currPattern.val)")
    }
    
    private func getColor(_: AnimationState) -> Color {
        switch(currPattern.animationState) {
            case .above:
                return .pink
            case .at:
                return .green
            case .under:
                return .blue
        }
    }
}
