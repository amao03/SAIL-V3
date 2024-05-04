//
//  IndicatorView.swift
//  v2-watch Watch App
//
//  Created by Alice Mao on 5/4/24.
//

import Foundation
import SwiftUI

struct IndicatorView: View {
    @Binding var animationState: AnimationState
    @State private var animationAmount = 1.0;
    @State private var animationDuration = 1.0;
    
    private func getColor(_: AnimationState) -> Color {
        switch(animationState) {
            case .above:
                return .pink
            case .at:
                return .blue
            case .below:
                return .green
        case .null:
            return .black
        }
    }
    
    var body: some View {
        VStack {
            Circle()
                .foregroundColor(getColor(animationState))
                .frame(width: 80, height: 80)
                .scaleEffect(animationAmount)
                .animation(
                    .easeInOut(duration: animationDuration)
                    .repeatForever(autoreverses: true),
                    value: animationAmount
                )
                .onChange(of: animationState) {
                    switch(animationState) {
                    case .above:
                        animationAmount = 0.8
                        animationDuration = 2.0
                    case .at:
                        animationAmount = 1.0
                        animationDuration = 1.0
                    case .below:
                        animationAmount = 1.0
                        animationDuration = 0.5
                    case .null:
                        animationAmount = 0
                        animationDuration = 0
                    }
                }
                .onAppear {
                    animationAmount = 1.2;
                }
        }
    }
}
