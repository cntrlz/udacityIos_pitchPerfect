//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by benchmark on 8/30/16.
//  Copyright © 2016 Viktor Lantos. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

	@IBOutlet weak var recordingLabel: UILabel!
	@IBOutlet weak var recordButton: UIButton!
	@IBOutlet weak var stopButton: UIButton!
	
	var audioRecorder : AVAudioRecorder!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		stopButton.enabled = false
		
	}
	
	override func viewWillAppear(animated: Bool) {
		print("View Will Appear")
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	

	@IBAction func recordAudio(sender: AnyObject) {
		print("Recording started...")
		recordingLabel.text = "Recording in Progress..."
		recordButton.enabled = false
		stopButton.enabled = true
		
		let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)[0] as String
		let recordingName = "recordedVoice.wav"
		let pathArray = [dirPath, recordingName]
		let filePath = NSURL.fileURLWithPathComponents(pathArray)
		print(filePath)
		
		let session = AVAudioSession.sharedInstance()
		try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
		
		try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
		audioRecorder.delegate = self
		audioRecorder.meteringEnabled = true
		audioRecorder.prepareToRecord()
		audioRecorder.record()
	}

	@IBAction func stopRecording(sender: AnyObject) {
		print("Recording stopped.")
		recordButton.enabled = true
		stopButton.enabled = false
		recordingLabel.text = "Tap to Record"
		
		audioRecorder.stop()
		let audioSession = AVAudioSession.sharedInstance()
		try! audioSession.setActive(false)
	}
	
	func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
		print("AVAudio has finished saving the recording")
		if (flag){
			self.performSegueWithIdentifier("stopRecording", sender: audioRecorder.url)
		} else {
			print("AVAudio failed to save the recording!")
		}
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if (segue.identifier == "stopRecording") {
			let playSoundsVC = segue.destinationViewController as! PlaySoundsViewController
			let recordedAudioURL = sender as! NSURL
			playSoundsVC.recordedAudioURL = recordedAudioURL
		}
	}
}

