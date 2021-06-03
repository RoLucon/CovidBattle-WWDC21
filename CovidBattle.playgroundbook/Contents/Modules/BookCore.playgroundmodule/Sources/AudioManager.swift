//
//  AudioManager.swift
//  PlaygroundBook
//
//  Created by Rogerio Lucon on 08/04/21.
//

import Foundation
import AVFoundation

protocol AudioPlayer {
    
    func play(music: Music)
    func stop(music: Music)
    
    func play(effect: Effect)
}

enum Effect {
    case success, failure, winner, loser
}

enum Music {
    case game, menu
}

public class AudioManager {
    static let shared = AudioManager()
    
    private var on: Music?
    private var musics = [Music: AVAudioPlayer]()
    private var effects = [Effect: AVAudioPlayer]()
    
    private init() {
        loadFile(music: .game, soundName: "SoundTrack01", type: "mp3")
        loadFile(music: .menu, soundName: "SoundTrack02", type: "mp3")
        loadFile(effect: .success, soundName: "ClickOk", type: "mp3")
        loadFile(effect: .failure, soundName: "ClickErro", type: "mp3")
        loadFile(effect: .winner, soundName: "Winner", type: "mp3")
        loadFile(effect: .loser, soundName: "Loser", type: "mp3")
    }
    
    private func loadFile(music: Music, soundName: String, type: String) {
        if let sound = loadFile(sound: soundName, type: type){
            self.musics.updateValue(sound, forKey: music)
        }
    }
    
    private func loadFile(effect: Effect, soundName: String, type: String) {
        if let sound = loadFile(sound: soundName, type: type){
            self.effects.updateValue(sound, forKey: effect)
        }
    }
    
    private func loadFile(sound: String, type: String) -> AVAudioPlayer? {
        if let path = Bundle.main.path(forResource: sound, ofType: type) {
            do {
                return try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            } catch {
                return nil
            }
        }
        return nil
    }
}

extension AudioManager: AudioPlayer {
    func play(music: Music) {
        if let current = on {
            musics[current]?.stop()
        }
        musics[music]?.play()
        musics[music]?.numberOfLoops = -1
        on = music
    }
    
    func stop(music: Music) {
        musics[music]?.stop()
        on = nil
    }
    
    func play(effect: Effect) {
        guard let effect = effects[effect] else { return }
        
        effect.play()
    }
    
    
}
