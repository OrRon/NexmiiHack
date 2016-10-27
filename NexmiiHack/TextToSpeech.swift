//
//  TextToSpeech.swift
//  NexmiiHack
//
//  Created by Vladimir Kofman on 28/10/2016.
//  Copyright © 2016 Or. All rights reserved.
//

import Foundation
import AVFoundation

class TextToSpeech : NSObject, AVSpeechSynthesizerDelegate {
    let speechSynthesizer = AVSpeechSynthesizer()
    
    func speak(text:String, locale:String? = nil) {
        speechSynthesizer.delegate = self
        
        if !speechSynthesizer.isSpeaking {

            let speechUtterance = AVSpeechUtterance(string: text)
            speechUtterance.rate = 0.5
            speechUtterance.pitchMultiplier = 1.0
            speechUtterance.volume = 1.0
            speechUtterance.postUtteranceDelay = 0.005
            
            if let voiceLanguageCode = locale {
                let voice = AVSpeechSynthesisVoice(language: voiceLanguageCode)
                speechUtterance.voice = voice
            }
            
            speechSynthesizer.speak(speechUtterance)
            
        }
        else{
            speechSynthesizer.continueSpeaking()
        }
    }
    
    func stop() {
        speechSynthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
    }
}
