//
//  FotoKTPViewController.swift
//  Final Challenge
//
//  Created by Tommy Ryanto on 08/11/19.
//  Copyright © 2019 Jesse Joseph. All rights reserved.
//

import UIKit
import AVFoundation

class FotoPribadiViewController: UIViewController {
    
    let cameraSession = AVCaptureSession()
    let captureSession = AVCaptureSession()
    let movieOutput = AVCaptureMovieFileOutput()
    var previewLayer: AVCaptureVideoPreviewLayer!
    var activeInput: AVCaptureDeviceInput!
    
    var outputURL: URL!
    
    var photoOutput = AVCapturePhotoOutput()

    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var cameraView: UIView!
    @IBAction func takePhotoButton(_ sender: UIButton) {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        self.photoOutput.capturePhoto(with: settings, delegate: self)
    }
    @IBAction func ulangiButton(_ sender: UIButton) {
    }
    @IBOutlet weak var ulangiOutlet: UIButton!
    @IBOutlet weak var lanjutOutlet: UIButton!
    @IBAction func lanjutButton(_ sender: UIButton) {
        performSegue(withIdentifier: "segueToFotoSIM", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if setupSession() {
            setupPreview()
            startSession()
        }
        
        self.resultImageView.isHidden = true
    }
}

// MARK: SETUP CAMERA PREVIEW
extension FotoPribadiViewController {
    
    func videoOrientationFromCurrentDeviceOrientation() -> AVCaptureVideoOrientation {
        switch UIApplication.shared.statusBarOrientation {
        case .portrait:
            return AVCaptureVideoOrientation.portrait
        case .landscapeLeft:
            return AVCaptureVideoOrientation.landscapeLeft
        case .landscapeRight:
            return AVCaptureVideoOrientation.landscapeRight
        case .portraitUpsideDown:
            return AVCaptureVideoOrientation.portraitUpsideDown
        default:
            // Can this happen?
            return AVCaptureVideoOrientation.portrait
        }
    }
    
    func setupSession() -> Bool {
        captureSession.sessionPreset = AVCaptureSession.Preset.high
        // Setup Camera
        let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)!
            do {
                let input = try AVCaptureDeviceInput(device: camera)
                if captureSession.canAddInput(input), captureSession.canAddOutput(photoOutput){
                    captureSession.addInput(input)
                    captureSession.addOutput(photoOutput)
                    activeInput = input
                }
            } catch {
                print("Error setting device camera input: \(error)")
                return false
            }
            return true
    }
    
    func setupPreview() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.connection?.videoOrientation = self.videoOrientationFromCurrentDeviceOrientation()
        previewLayer.frame = cameraView.bounds
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraView.layer.addSublayer(previewLayer)
    }

    func startSession() {
        if !captureSession.isRunning {
            DispatchQueue.main.async {
                self.captureSession.startRunning()
            }
        }
    }
}

extension FotoPribadiViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        print("processing photo")
        guard let imageData = photo.fileDataRepresentation() else { return }
        let image = UIImage(data: imageData)
        resultImageView.image = image
        self.captureSession.stopRunning()
        self.resultImageView.isHidden = false
        self.lanjutOutlet.isHidden = false
        self.ulangiOutlet.isHidden = false
    }
}
