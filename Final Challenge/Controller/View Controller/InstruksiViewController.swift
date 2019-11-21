//
//  InstruksiViewController.swift
//  Final Challenge
//
//  Created by Tommy Ryanto on 08/11/19.
//  Copyright © 2019 Jesse Joseph. All rights reserved.
//

import UIKit
import AVFoundation

class InstruksiViewController: UIViewController {
    let cameraSession = AVCaptureSession()
    let captureSession = AVCaptureSession()
    let movieOutput = AVCaptureMovieFileOutput()
    var previewLayer: AVCaptureVideoPreviewLayer!
    var activeInput: AVCaptureDeviceInput!

    @IBOutlet weak var cameraView: UIView!
    @IBAction func mulaiTestButton(_ sender: RoundedButton) {
        self.performSegue(withIdentifier: "mulaiTest", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if setupSession() {
            setupPreview()
            startSession()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.previewLayer.frame = self.cameraView.layer.bounds
    }
    
    
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
    
}
