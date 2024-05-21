//
//  Select_Patterns.swift
//  sail-v1
//
//  Created by Alice Mao on 12/8/23.
//

import Foundation
import SwiftUI

struct MadeHapticsSelectorView:View{
    @Binding var selectedItems: MadePattern
    @State var hapticString: String = ""
    
    var body: some View {
        VStack{
            Form{
                List{
                    ForEach(MadePatternsList.madePatternsList) { haptic in
                        Button(action: {
                            withAnimation{
                                if self.selectedItems == haptic{
                                    self.selectedItems = MadePattern()
                                } else{
                                    self.selectedItems = haptic
                                }
                            }
                        }) {
                            HStack{
                                Text("\(haptic.name)")
                                Spacer()
                                if self.selectedItems == haptic{
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                }
                Text("**Selected:** \(selectedItems.name)")
                Text("**Description:** \(selectedItems.description)")
            }
            .navigationTitle("Choose haptics")
        }
    }
}

#Preview {
    ContentView()
//    MadeHapticsSelectorView(selectedItems: .constant(MadePattern()))
}
