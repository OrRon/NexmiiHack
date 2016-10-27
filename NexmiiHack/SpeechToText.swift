//
//  SpeechToText.swift
//  NexmiiHack
//
//  Created by Vladimir Kofman on 28/10/2016.
//  Copyright © 2016 Or. All rights reserved.
//

import Foundation
import Speech


class SpeechToText : NSObject, SFSpeechRecognizerDelegate {
    
    private var speechRecognizer : SFSpeechRecognizer!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    var receivedText:String = ""
    
    func authorize() {
        SFSpeechRecognizer.requestAuthorization { _ in
            // ignore for now...
        }
    }
    
    func start(locale:String) {
        self.speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: locale))!
        
        if audioEngine.isRunning {
           _ = self.stop()
        } else {
            startRecording()
        }
    }
    
    func stop() -> String {
        audioEngine.stop()
        //audioEngine.reset()
        recognitionRequest?.endAudio()
        
        return receivedText
    }
    
    ///////
    
    func startRecording() {
        
        if recognitionTask != nil {  //1
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()  //2
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()  //3
        
        guard let inputNode = audioEngine.inputNode else {
            fatalError("Audio engine has no input node")
        }  //4
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        } //5
        
        recognitionRequest.shouldReportPartialResults = true  //6
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in  //7
            
            var isFinal = false  //8
            
            if result != nil {
                
                //self.textView.text = result?.bestTranscription.formattedString  //9
                
                if let tmpText = result?.bestTranscription.formattedString {
                    self.receivedText = tmpText
                }
                
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {  //10
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                //self.microphoneButton.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)  //11
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()  //12
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        //textView.text = "Say something, I'm listening!"
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
//        if available {
//            microphoneButton.isEnabled = true
//        } else {
//            microphoneButton.isEnabled = false
//        }
    }
    
}
