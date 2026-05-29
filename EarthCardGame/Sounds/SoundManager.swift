import Foundation
import AVFoundation

class SoundManager {
    static let instance = SoundManager()
    
    var bgMusicPlayer: AVAudioPlayer?
    var flipPlayer: AVAudioPlayer?
    var winPlayer: AVAudioPlayer?
    
    init() {
        if let flipUrl = Bundle.main.url(forResource: "flip", withExtension: "mp3") {
            flipPlayer = try? AVAudioPlayer(contentsOf: flipUrl)
            flipPlayer?.prepareToPlay()
        }
        
        if let winUrl = Bundle.main.url(forResource: "win", withExtension: "mp3") {
            winPlayer = try? AVAudioPlayer(contentsOf: winUrl)
            winPlayer?.prepareToPlay()
        }
    }
    
    func playBackgroundMusic() {
            guard let url = Bundle.main.url(forResource: "bg_music", withExtension: "mp3") else { return }
            do {
                bgMusicPlayer = try AVAudioPlayer(contentsOf: url)
                
                bgMusicPlayer?.volume = 0.2
                
                bgMusicPlayer?.numberOfLoops = -1
                bgMusicPlayer?.play()
            } catch {
                print("Error playing background music")
            }
        }
    
    func pauseBackgroundMusic() {
        bgMusicPlayer?.pause()
    }
    
    func resumeBackgroundMusic() {
        bgMusicPlayer?.play()
    }
    
    func playFlipSound() {
        flipPlayer?.currentTime = 0
        flipPlayer?.play()
    }
    
   
        func playWinSound() {
           
            pauseBackgroundMusic()
            
             
            winPlayer?.volume = 1.0
            
            // 3. מנגנים את הצליל
            winPlayer?.currentTime = 0
            winPlayer?.play()
        }
}
