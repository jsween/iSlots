//
//  PlaySound.swift
//  iSlots
//
//  Created by Jonathan Sweeney on 11/28/20.
//

import AVFoundation

var audioPlayer: AVAudioPlayer?

func playSound(sound: String, type: String = "mp3") {
    if let path = Bundle.main.path(forResource: sound, ofType: type) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
        } catch {
            print("ERROR: Unable to play sound file.")
        }
    }
}
