//
//  SetConfigs.swift
//  sail-v3
//
//  Created by Alice Mao on 12/10/24.
//

import SwiftUI
import AVFoundation

struct SetUnderPattern : View {
    @EnvironmentObject var currTest : Test
    @State var audioPlayer: AVAudioPlayer?
    
    var body: some View {
        VStack{
            Text("**Select under sound**")
            Picker("Sound", selection: $currTest.underSound) {
                ForEach(sounds, id: \.self) { sound in
                    Text(sound)
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 120)
//            .onReceive([self.currTest.atSound].publisher.first()) { value in
//                        self.playSound(fileName: currTest.atSound)
//             }
            Text("play the full audio clip")
            Button(action: {playSound(fileName: currTest.underSound)}) {
                Text("play \(currTest.underSound)")
            }
            .font(.system(size: 24))
            .buttonStyle(.bordered)
        }.padding(30)
    }
    
    func playSound(fileName: String) {
        var fullFileName = fileName
        audioPlayer?.stop()
        audioPlayer = nil
        
        print("play sound")
        let url = Bundle.main.url( forResource: fullFileName, withExtension: "mp3")
        
        audioPlayer = try! AVAudioPlayer(contentsOf: url!)
        audioPlayer?.volume = 1
        audioPlayer?.play()
    }
}

