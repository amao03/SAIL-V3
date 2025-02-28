//
//  SetConfigs.swift
//  sail-v3
//
//  Created by Alice Mao on 12/10/24.
//

import SwiftUI
import AVFoundation

struct SetAtPattern : View {
    @EnvironmentObject var currTest : Test
    @State var audioPlayer: AVAudioPlayer?
    
    var body: some View {
        VStack{
            Text("**Select at sound**")
            Picker("Sound", selection: $currTest.atSound) {
                ForEach(sounds, id: \.self) { sound in
                    Text(sound)
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 120)
//            .onReceive([self.currTest.atSound].publisher.first()) { value in
//                        self.playSound(fileName: currTest.atSound)
//             }
            
            Button(action: {playSound(fileName: currTest.atSound)}) {
                Text("play \(currTest.atSound)")
            }
            .font(.system(size: 24))
            .buttonStyle(.bordered)
        }.padding(30)
    }
    
    func playSound(fileName: String) {
        var fullFileName = fileName + "-crop"
        audioPlayer?.stop()
        audioPlayer = nil
        
        print("play sound")
        let url = Bundle.main.url( forResource: fullFileName, withExtension: "mp3")
        
        audioPlayer = try! AVAudioPlayer(contentsOf: url!)
        audioPlayer?.volume = 1
        audioPlayer?.play()
    }
}
