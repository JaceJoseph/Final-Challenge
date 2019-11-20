//
//  TestSection2ViewController.swift
//  Final Challenge
//
//  Created by Tommy Ryanto on 12/11/19.
//  Copyright © 2019 Jesse Joseph. All rights reserved.
//

import UIKit
import AVFoundation

protocol SegueHandler: class {
    func segueToNext(identifier: String)
}

class TestSection2ViewController: UIViewController,SegueHandler {
    let cameraSession = AVCaptureSession()
    let captureSession = AVCaptureSession()
    let movieOutput = AVCaptureMovieFileOutput()
    var previewLayer: AVCaptureVideoPreviewLayer!
    var activeInput: AVCaptureDeviceInput!
    var outputURL: URL!
    
    var timer = Timer()
    var minutes: Int = 0
    var seconds: Int = 0

    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        if setupSession() {
            setupPreview()
            startSession()
        }
        
        startRecording()
        setupTimeLimit()
    }
}

// MARK: CONFIGURE TIMER
extension TestSection2ViewController {
    func setupTimeLimit() {
        minutes = 15
        seconds = 0
        updateLabel()
        configureTimer()
    }
    
    func updateLabel() {
        minutesLabel.text = String(format: "%02d", minutes)
        secondLabel.text = String(format: "%02d", seconds)
    }
    
    func configureTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            self.updateTimer()
        })
    }
    
    func updateTimer() {
        if seconds == 0 {
            minutes -= 1
            seconds = 59
        } else if seconds != 0 {
            seconds -= 1
        } else if seconds == 0, minutes == 0 {
            print("test done")
            self.timer.invalidate()
        } else {
            print("wait, whut?")
        }
        updateLabel()
    }
}

// MARK: SETTING UP THE CAMERA SESSION
extension TestSection2ViewController {
    func setupSession() -> Bool {
        captureSession.sessionPreset = AVCaptureSession.Preset.high
        // Setup Camera
        let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)!
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
                activeInput = input
            }
        } catch {
            print("Error setting device video input: \(error)")
            return false
        }
        // Setup Microphone
        let microphone = AVCaptureDevice.default(for: AVMediaType.audio)!

        do {
            let micInput = try AVCaptureDeviceInput(device: microphone)
            if captureSession.canAddInput(micInput) {
                captureSession.addInput(micInput)
            }
        } catch {
            print("Error setting device audio input: \(error)")
            return false
        }
        // Movie output
        if captureSession.canAddOutput(movieOutput) {
            captureSession.addOutput(movieOutput)
        }
        return true
    }
    
    func setupPreview() {
        // Configure previewLayer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = cameraView.bounds
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.connection?.videoOrientation = self.currentVideoOrientation()
        cameraView.layer.addSublayer(previewLayer)
    }

    func startSession() {
        if !captureSession.isRunning {
            DispatchQueue.main.async {
                self.captureSession.startRunning()
            }
       }
    }
    
    func currentVideoOrientation() -> AVCaptureVideoOrientation {
       var orientation: AVCaptureVideoOrientation

        switch UIApplication.shared.statusBarOrientation {
           case .portrait:
               orientation = AVCaptureVideoOrientation.portrait
           case .landscapeRight:
               orientation = AVCaptureVideoOrientation.landscapeRight
           case .portraitUpsideDown:
               orientation = AVCaptureVideoOrientation.portraitUpsideDown
            case .landscapeLeft:
                orientation = AVCaptureVideoOrientation.landscapeLeft
            default:
                orientation = AVCaptureVideoOrientation.landscapeRight
        }

        return orientation
    }
    
    func startRecording() {
        let connection = movieOutput.connection(with: AVMediaType.video)
        if (connection?.isVideoOrientationSupported)! {
            connection?.videoOrientation = currentVideoOrientation()
        }
        if (connection?.isVideoStabilizationSupported)! {
            connection?.preferredVideoStabilizationMode = AVCaptureVideoStabilizationMode.auto
        }

        let device = activeInput.device
        if (device.isSmoothAutoFocusSupported) {
            do {
                try device.lockForConfiguration()
                device.isSmoothAutoFocusEnabled = false
                device.unlockForConfiguration()
            } catch {
                print("Error setting configuration: \(error)")
            }
        }
        //EDIT2: And I forgot this
        DispatchQueue.main.async {
            self.outputURL = self.tempURL()
            self.movieOutput.startRecording(to: self.outputURL, recordingDelegate: self)
        }
    }

    func tempURL() -> URL? {
        let directory = NSTemporaryDirectory() as NSString

        if directory != "" {
            let path = directory.appendingPathComponent(NSUUID().uuidString + ".mp4")
            return URL(fileURLWithPath: path)
        }

        return nil
    }
    
    func segueToNext(identifier: String) {
        self.performSegue(withIdentifier: identifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedSegue" {
            let dvc = segue.destination as! TestSection1AViewController
            dvc.delegate = self
        }
    }
}

// MARK: HANDLING THE VIDEO OUTPUT
extension TestSection2ViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        print("recording finished")
        if let error = error {
            print(error.localizedDescription)
        } else {
            let videoRecorded = outputURL! as URL
        }
    }
}
