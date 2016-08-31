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

	@IBAction func recordAudio(sender: AnyObject) {
		setupViewForRecording(true)
		
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
		setupViewForRecording(false)
		
		audioRecorder.stop()
		let audioSession = AVAudioSession.sharedInstance()
		try! audioSession.setActive(false)
	}
	
	// Swap view states
	func setupViewForRecording(recording : Bool){
		if recording {
			recordingLabel.text = "Recording in Progress..."
			recordButton.enabled = false
			stopButton.enabled = true
		} else {
			recordingLabel.text = "Tap to Record"
			recordButton.enabled = true
			stopButton.enabled = false
		}
	}
	
	func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
		if flag {
			performSegueWithIdentifier("stopRecording", sender: audioRecorder.url)
		} else {
			let alert = UIAlertController(title: title, message: "AVAudio failed to save the recording!", preferredStyle: .Alert)
			alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
			presentViewController(alert, animated: true, completion: nil)
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

