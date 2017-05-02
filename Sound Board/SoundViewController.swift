//
//  SoundViewController.swift
//  Sound Board
//
//  Created by Bradley Stovall on 4/11/17.
//  Copyright © 2017 Bradley Stovall. All rights reserved.
//

import UIKit
import AVFoundation


class SoundViewController: UIViewController {
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    var audioRecorder : AVAudioRecorder?
    var audioPlayer : AVAudioPlayer?
    var audioURL : URL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setupRecorder()
        playButton.isEnabled = false
        addButton.isEnabled = false
    }
    
    func setupRecorder() {
        do {
            //Create Audio session
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            
            //Create URL for the audio file
            let basePath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath, "audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            
            
            //Create Settings for the audio recorder
            var settings : [String:Any] = [:]
            
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC)
            settings[AVSampleRateKey] = 44100.0
            settings[AVNumberOfChannelsKey] = 2
            // Create AudioRecorder Object
            
            audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
            audioRecorder!.prepareToRecord()
            
        } catch let error as NSError {
            print (error)
        }
    }
    
    @IBAction func recordTapped(_ sender: Any) {
        
        if audioRecorder!.isRecording {
            //Stop the recording
            audioRecorder?.stop()
            playButton.isEnabled = true
            addButton.isEnabled = true
            
            //Change button title to Record
            recordButton.setTitle("Record", for: .normal)
        } else {
            //Start the recording
            audioRecorder?.record()
            //Change button title to Stop
            recordButton.setTitle("Stop", for: .normal)
        }
        
            
        }
        @IBAction func playTapped(_ sender: Any) {
            do {
                try audioPlayer = AVAudioPlayer(contentsOf: audioURL!)
                audioPlayer!.play()
            } catch {}
        }
        @IBAction func addTapped(_ sender: Any) {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let sound = Sound(context: context)
            sound.name = nameTextField.text
            sound.audio = NSData(contentsOf: audioURL!)
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            navigationController!.popViewController(animated: true)
            
            
        }
        
        
}
