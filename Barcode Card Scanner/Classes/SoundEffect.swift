/*
 Description: This is a class to play specific sounds
 Author: Stefano Gregor Unlayao
 Date: 2018-12-09
 */

import UIKit
import AVFoundation

class SoundEffect: NSObject, AVAudioPlayerDelegate {
    // Properties
    private var volume: Float                                   // Volume of the audio to be played
    private var soundPlayer : AVAudioPlayer?                    // The audio player
    
    // Initializes the volume & AVAudioPlayer properties when the object is created
    init(_ volume: Double) {
        self.volume = Float(volume)
        soundPlayer?.currentTime = 0
        soundPlayer?.numberOfLoops = 1
    }
    
    // Initializes sound based on input
    func setSoundEffect(resourceName: String){
        if let soundURL = Bundle.main.path(forResource: resourceName, ofType: ".mp3") {
            let url = URL(fileURLWithPath: soundURL)
            do {
                soundPlayer = try AVAudioPlayer.init(contentsOf:url)
            } catch _ as NSError {
                soundPlayer = nil
            }
        }
    }
    
    // Sets the volume
    func setVolume(volume: Float) {
        self.volume = volume
    }
    
    // Gets the volume
    func getVolume() -> Float {
        return self.volume
    }
    
    // Play the sound effect
    func play(){
        soundPlayer?.volume = self.volume
        soundPlayer?.play()
    }
    
    // Stop the sound effect
    func stop(){
        soundPlayer?.stop()
    }
}
