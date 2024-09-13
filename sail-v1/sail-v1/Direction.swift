////
////  Direction.swift
////  sail-v1
////
////  Created by Alice Mao on 8/6/24.
////
//
//import Foundation
//import SwiftUI
//
//struct CompassMarkerView: View {
//    let marker: Marker
//    let compassDegress: Double
//
//    var body: some View {
//        VStack {
//            Text(marker.degreeText())
//                    .fontWeight(.light)
//                    .rotationEffect(self.textAngle())
//
//            Capsule()
//                    .frame(width: self.capsuleWidth(),
//                            height: self.capsuleHeight())
//                    .foregroundColor(self.capsuleColor())
//                    .padding(.bottom, 120)
//
//            Text(marker.label)
//                    .fontWeight(.bold)
//                    .rotationEffect(self.textAngle())
//                    .padding(.bottom, 80)
//        }.rotationEffect(Angle(degrees: marker.degrees))
//    }
//    
//    private func capsuleWidth() -> CGFloat {
//        return self.marker.degrees == 0 ? 7 : 3
//    }
//    
//    private func capsuleHeight() -> CGFloat {
//        return self.marker.degrees == 0 ? 45 : 30
//    }
//    
//    private func capsuleColor() -> Color {
//        return self.marker.degrees == 0 ? .red : .gray
//    }
//    
//    private func textAngle() -> Angle {
//        return Angle(degrees: -self.compassDegress - self.marker.degrees)
//    }
//}
