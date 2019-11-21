//
//  FotoKTPViewController.swift
//  Final Challenge
//
//  Created by Tommy Ryanto on 08/11/19.
//  Copyright © 2019 Jesse Joseph. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

class FotoKTPViewController: UIViewController {
    
    let cameraSession = AVCaptureSession()
    let captureSession = AVCaptureSession()
    let movieOutput = AVCaptureMovieFileOutput()
    var previewLayer: AVCaptureVideoPreviewLayer!
    var activeInput: AVCaptureDeviceInput!
    var outputURL: URL!
    var photoOutput = AVCapturePhotoOutput()
    
    //variables for vision text
    var bufferText: String?
    var tempatIndex: String?
    var tglLahirIndex: Int?
    lazy var textDetectionRequest: VNRecognizeTextRequest = {
        let request = VNRecognizeTextRequest(completionHandler: self.handleDetectedText)
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["id"]
        return request
    }()
    var detectedText = [String]()
    var textRecognitionRequest = VNRecognizeTextRequest(completionHandler: nil)
    private let textRecognitionWorkQueue = DispatchQueue(label: "MyVisionScannerQueue", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    var noSim: String?
    var nik: String?
    var namaUser: String?
    var jenisKelamin: String?
    var berlaku: String?
    var alamatUser: String?
    var tempatUser: String?
    var tanggalLahirUser: String?

    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var cameraView: UIView!
    @IBAction func takePhotoButton(_ sender: UIButton) {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        self.photoOutput.capturePhoto(with: settings, delegate: self)
    }
    @IBAction func ulangiButton(_ sender: UIButton) {
        self.resultImageView.isHidden = true
        if setupSession() {
            setupPreview()
            startSession()
            self.ulangiOutlet.isHidden = true
            self.lanjutOutlet.isHidden = true
        }
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.previewLayer.frame = self.cameraView.layer.bounds
    }
}

// MARK: SETUP CAMERA PREVIEW
extension FotoKTPViewController {
    
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
        let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)!
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

extension FotoKTPViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        print("processing photo")
        guard let imageData = photo.fileDataRepresentation() else { return }
        let image = UIImage(data: imageData)
        resultImageView.image = image
        self.captureSession.stopRunning()
        processImage() {
            DispatchQueue.main.async {
                self.resultImageView.isHidden = false
                self.lanjutOutlet.isHidden = false
                self.ulangiOutlet.isHidden = false
                UserDefaults.standard.set(imageData, forKey: "imageKTP")
                print("KTP image added to user defaults successfully")
            }
        }
    }
}

extension FotoKTPViewController {
    func processImage(completion: @escaping () -> ()) {
        self.detectedText.removeAll()
        guard let image = self.resultImageView.image, let cgImage = image.cgImage else { return }
        let requests = [textDetectionRequest]
        let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage, orientation: .up, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try imageRequestHandler.perform(requests)
                completion()
            } catch let error {
                print(error)
            }
        }
    }
    
    func handleDetectedText(request: VNRequest?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        }
        guard let results = request?.results, results.count > 0 else {
            print("No text detected")
            return
        }
        
        self.detectedText.removeAll()
        
        var confidence: Float = 0.0
        var numberOfText: Float = 0.0
        
        for result in results {
            if let observation = result as? VNRecognizedTextObservation {
                for text in observation.topCandidates(1) {
                    //print("Text: \(text.string)")
                    numberOfText += 1.0
                    print(text.confidence)
                    confidence += text.confidence
                    self.detectedText.append(text.string)
                }
            }
        }
        
        print("average confidence: \(confidence/numberOfText)")
        
        var counter = 0
        for validate in self.detectedText {
            print("Text \(counter): \(validate)")
            counter += 1
        }
        
        DispatchQueue.main.async {
            for (counter, text) in self.detectedText.enumerated() {

                /*var namaUser: String?
                var alamatUser: String?
                var tempatUser: String?
                var tanggalLahirUser: String?*/
                if text.uppercased().contains("NIK") {
                    self.bufferText = text.replacingOccurrences(of: "NIK", with: "")
                    self.removeBuffer()
                    self.nik = self.detectedText[counter+1]
                    print("NIK: \(self.nik!)")
                    UserDefaults.standard.set(self.nik!, forKey: "NIK")
                } else if text.uppercased().contains("NAMA") {
                    self.bufferText = text.replacingOccurrences(of: "Nama", with: "")
                    self.removeBuffer()
                    self.namaUser = self.detectedText[counter+1]
                    print("namaUser: \(self.namaUser!)")
                    UserDefaults.standard.set(self.namaUser!, forKey: "nama")
                } else if text.uppercased().contains("ALAMAT") {
                    self.bufferText = text.replacingOccurrences(of: "Alamat", with: "")
                    self.removeBuffer()
                    self.alamatUser = self.bufferText
                    if (self.alamatUser?.uppercased().contains("alamat"))! || self.alamatUser == "" {
                        self.alamatUser = self.detectedText[counter+1]
                    }
                    self.alamatUser = "Alamat: \(self.bufferText ?? "")"
                    UserDefaults.standard.set(self.alamatUser, forKey: "alamat")
                } else if text.uppercased().contains("JENIS KELAMIN") {
                    self.jenisKelamin = self.detectedText[counter+1]
                    UserDefaults.standard.set(self.jenisKelamin!, forKey: "jenisKelamin")
                } else if text.uppercased().contains("TEMPAT") {
                    self.tempatUser = self.detectedText[counter+1]
                } else if text.uppercased().contains("LAHIR") {
                    self.tanggalLahirUser = self.detectedText[counter+1]
                } else if text.uppercased().contains("BERLAKU") {
                    self.bufferText = text.replacingOccurrences(of: "Berlaku", with: "")
                    self.bufferText = self.bufferText?.replacingOccurrences(of: "s/d", with: "")
                    self.bufferText = self.bufferText?.replacingOccurrences(of: "sid", with: "")
                    self.removeBuffer()
                    self.berlaku = self.bufferText
                } else if text.uppercased().contains("KAPOLRES") {
                    var tanggalBerlaku = self.detectedText[counter-1].suffix(11)
                    var tahunPembuatan = tanggalBerlaku.suffix(5)
                    if tahunPembuatan.contains(".") || tahunPembuatan.contains(" ") {
                        tahunPembuatan = "\(tahunPembuatan.replacingOccurrences(of: ".", with: ""))"
                        tahunPembuatan = "\(tahunPembuatan.replacingOccurrences(of: " ", with: ""))"
                        var tahunBerlaku = 0
                        if let tahunPembuatanInteger = Int(tahunPembuatan) {
                            tahunBerlaku = tahunPembuatanInteger + 5
                            tanggalBerlaku = "\(tanggalBerlaku.replacingOccurrences(of: "\(tahunPembuatan)", with: "\(tahunBerlaku)"))"
                            self.berlaku = "\(tanggalBerlaku)"
                        }
                    }
                } else if text.uppercased().contains("SIM") {
                    self.noSim = "\(text.suffix(12))"
                }
            }
        }
    }
    
    func removeBuffer() {
        bufferText = bufferText?.replacingOccurrences(of: ":", with: "")
    }
}
