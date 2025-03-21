//
//  SetConfigs.swift
//  sail-v3
//
//  Created by Alice Mao on 12/10/24.
//

import SwiftUI
import AVFoundation

struct SetAbovePattern : View {
    @EnvironmentObject var currTest : Test
    @State var audioPlayer: AVAudioPlayer?
    
    var body: some View {
        VStack{
            Text("**Select above sound**")
            Picker("Sound", selection: $currTest.aboveSound) {
                ForEach(sounds, id: \.self) { sound in
                    Text(sound)
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 120)
//            .onReceive([self.currTest.atSound].publisher.first()) { value in
//                        self.playSound(fileName: currTest.atSound)
//             }
            Text("play the 1s audio clip")
            Button(action: {playSound(fileName: currTest.aboveSound)}) {
                Text("play \(currTest.aboveSound)")
            }
            .font(.system(size: 24))
            .buttonStyle(.bordered)
        }.padding(30)
    }
    
    func playSound(fileName: String) {
        var fullFileName = "1s_"+fileName
        audioPlayer?.stop()
        audioPlayer = nil
        
        print("play sound")
        let url = Bundle.main.url( forResource: fullFileName, withExtension: "mp3")
        
        audioPlayer = try! AVAudioPlayer(contentsOf: url!)
        audioPlayer?.volume = 1
        audioPlayer?.play()
    }
}
