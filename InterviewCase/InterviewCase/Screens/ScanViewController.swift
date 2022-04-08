//
//  ScanViewController.swift
//  InterviewCase
//
//  Created by Maviye Çökelez on 7.04.2022.
//


import AVFoundation
import UIKit



class ScanViewController: UIViewController {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var qrCodeFrameView: UIView?
    
    @IBOutlet weak var qrView: UIImageView!
    
    let systemSoundID: SystemSoundID = 1016
    
    override func viewDidLoad() {
        super.viewDidLoad()
        qrView.layer.borderWidth = 2
        qrView.layer.borderColor = UIColor.green.cgColor
        
        start()
        
    }
    
    func start(){
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .high
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            //FORMATS OF BARCODE
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417, .code39, .code128, .qr]
        } else {
            failed()
            
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        view.bringSubviewToFront(qrView)
        captureSession.startRunning()
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .black
        
    }
    
    func found(code: String) {
        
        AudioServicesPlaySystemSound(systemSoundID)
        print("CODE => \(code)")
        
        let ac = UIAlertController(title: "Scanning Success", message: "\(code)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "AnimationVCNavigation")
                destVC.modalPresentationStyle = .overCurrentContext
                destVC.modalTransitionStyle = .crossDissolve
                self.present(destVC, animated: true, completion: nil)
            }
            
        }))
        
        self.present(ac, animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}



extension ScanViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            let barCodeObject = previewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                self.found(code: metadataObj.stringValue!)
            }
        }
    }
}








//class ScanViewController: UIViewController {
//
//    var captureSession = AVCaptureSession()
//    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
//    var qrCodeFrameView: UIView?
//
//    @IBOutlet weak var qrView: UIImageView!
//
//    var code: String!
//    let systemSoundID: SystemSoundID = 1016
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = UIColor.black
//        qrView.layer.borderWidth = 2
//        qrView.layer.borderColor = UIColor.green.cgColor
//
//        view.isUserInteractionEnabled = true
//
//        // Get the back-facing camera for capturing videos
//        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)
//
//        guard let captureDevice = deviceDiscoverySession.devices.first else {
//            print("Failed to get the camera device")
//            return
//        }
//
//        do {
//            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
//            let input = try AVCaptureDeviceInput(device: captureDevice)
//
//            // Set the input device on the capture session.
//            captureSession.addInput(input)
//
//        } catch {
//            // If any error occurs, simply print it out and don't continue any more.
//            print(error)
//            return
//        }
//
//        let captureMetadataOutput = AVCaptureMetadataOutput()
//        captureSession.addOutput(captureMetadataOutput)
//
//        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
//        captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
//
//        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
//        videoPreviewLayer?.frame = view.layer.bounds
//        videoPreviewLayer?.backgroundColor = CGColor(red: 11, green: 17, blue: 39, alpha: 0.7)
//        view.layer.addSublayer(videoPreviewLayer!)
//
//        captureSession.startRunning()
//
//        qrCodeFrameView = UIView()
//
//        if let qrCodeFrameView = qrCodeFrameView {
//            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
//            qrCodeFrameView.layer.borderWidth = 2
//            view.addSubview(qrCodeFrameView)
//            view.bringSubviewToFront(qrCodeFrameView)
//        }
//
//    }
//
////    @objc func swipe(){
////        self.dismiss(animated: true, completion: nil)
////    }
////
////    func reStart(){
////        captureSession = AVCaptureSession()
////        captureSession.sessionPreset = .high
////        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
////        let videoInput: AVCaptureDeviceInput
////
////        do {
////            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
////        } catch {
////            return
////        }
////
////        if (captureSession.canAddInput(videoInput)) {
////            captureSession.addInput(videoInput)
////        } else {
////            self.failed()
////            return
////        }
////
////        let metadataOutput = AVCaptureMetadataOutput()
////
////        if (captureSession.canAddOutput(metadataOutput)) {
////            captureSession.addOutput(metadataOutput)
////
////            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
////            //FORMATS OF BARCODE
////            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417, .code39, .code128, .qr]
////        } else {
////            self.failed()
////            return
////        }
////
////        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
////        previewLayer.frame = view.layer.bounds
////        previewLayer.videoGravity = .resizeAspectFill
////        view.layer.addSublayer(previewLayer)
////        view.bringSubviewToFront(qrView)
////        captureSession.startRunning()
////    }
////
////    func failed() {
////        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
////        ac.addAction(UIAlertAction(title: "OK", style: .default))
////        present(ac, animated: true)
////        captureSession = nil
////    }
////
////    override func viewWillAppear(_ animated: Bool) {
////        super.viewWillAppear(animated)
////
////        if (captureSession?.isRunning == false) {
////            captureSession.startRunning()
////        }
////    }
////
////    override func viewWillDisappear(_ animated: Bool) {
////        super.viewWillDisappear(animated)
////
////        if (captureSession?.isRunning == true) {
////            captureSession.stopRunning()
////        }
////    }
////
//    func found(code: String) {
//
//        AudioServicesPlaySystemSound(systemSoundID)
//        print("CODE => \(code)")
//
//        let ac = UIAlertController(title: "Scanning Success", message: "\(code)", preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: {
//            _ in
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//                let destVC = storyBoard.instantiateViewController(withIdentifier: "AnimationVCNavigation")
//                destVC.modalPresentationStyle = .overFullScreen
//                self.present(destVC, animated: true, completion: nil)
//            }
//
//        }))
//
//        self.present(ac, animated: true)
//    }
//
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
//
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return .portrait
//    }
//}
//
//extension ScanViewController: AVCaptureMetadataOutputObjectsDelegate {
//    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
//        // Check if the metadataObjects array is not nil and it contains at least one object.
//            if metadataObjects.count == 0 {
//                qrCodeFrameView?.frame = CGRect.zero
//                return
//            }
//
//            // Get the metadata object.
//            let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
//
//            if metadataObj.type == AVMetadataObject.ObjectType.qr {
//                // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
//                let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
//                qrCodeFrameView?.frame = barCodeObject!.bounds
//
//                if metadataObj.stringValue != nil {
//                    self.found(code: metadataObj.stringValue!)
//                }
//            }
//    }
//}
