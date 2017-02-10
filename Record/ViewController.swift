//
//  ViewController.swift
//  Record
//
//  Created by Jack K on 2/7/17.
//  Copyright © 2017 Jack K. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playButton.isEnabled = false
        stopButton.isEnabled = false
        
        // location for sound file
        let fileMgr = FileManager.default
        let dirPaths = fileMgr.urls(for: .documentDirectory, in: .userDomainMask)
        let soundFileURL = dirPaths[0].appendingPathComponent("sound.wav")
        
        // settings for recording, can be changed to liking
        let recordSettings = [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
                              AVEncoderBitRateKey: 16,
                              AVNumberOfChannelsKey: 2,
                              AVSampleRateKey: 44100.0] as [String: Any]
        
        // activating app's audio session
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
        }
        catch let error as NSError{
            print("audioSession error: \(error.localizedDescription)")
        }
        
        // initializing our audio recording capabilities
        do{
            try audioRecorder = AVAudioRecorder(url: soundFileURL, settings: recordSettings)
            audioRecorder?.prepareToRecord()
        }
        catch let error as NSError{
            print("audioSession error: \(error.localizedDescription)")
        }
        
    }

    // functions related to our buttons
    
    @IBAction func recordAudio(_ sender: Any) {
        if audioRecorder?.isRecording == false{
            recordButton.isEnabled = false
            playButton.isEnabled = false
            stopButton.isEnabled = true
            audioRecorder?.record()
        }
    }
    
    @IBAction func stopAudio(_ sender: Any) {
        stopButton.isEnabled = false
        playButton.isEnabled = true
        recordButton.isEnabled = true
        
        if audioRecorder?.isRecording == true{
            audioRecorder?.stop()
        }
        else{
            audioPlayer?.stop()
        }
    }

    @IBAction func playAudio(_ sender: Any) {
        if audioRecorder?.isRecording == false{
            stopButton.isEnabled = true
            recordButton.isEnabled = false
            
            do{
                // must provide the sound file location in audio player init
                try audioPlayer = AVAudioPlayer(contentsOf: (audioRecorder?.url)!)
                audioPlayer!.delegate = self
                audioPlayer!.prepareToPlay()
                audioPlayer!.play()
            }
            catch let error as NSError{
                print("audioPlayer error: \(error.localizedDescription)")
            }
        }
    }
    
    // delegate functions
    // can detect when the system is done playing audio, or when the recorder can't record anymore
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordButton.isEnabled = true
        stopButton.isEnabled = false
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Audio Play Decode Error")
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Audio Record Encode Error")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

