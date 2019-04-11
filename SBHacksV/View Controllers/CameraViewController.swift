//
//  PhotoViewController.swift
//  OCRCurrencyConverter
//
//  Created by 王传正 on 2019/1/11.
//  Copyright © 2019 zcgr. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {

    @IBOutlet weak var cameraView: UIImageView!
    @IBOutlet weak var takePicture: UIButton!
    
    private var captureDevice = AVCaptureDevice.default(for: .video)!
    private let camera = Camera()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        camera.delegate = self
        camera.setupCaptureSession()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination
        if segue.identifier == "Result" {
            let vc = vc as! ResultViewController
            vc.delegate = self
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func takePictureAction(_ sender: UIButton) {
        
    }
}

extension CameraViewController: CameraDelegate {
    
    func setupCameraView(with layer: AVCaptureVideoPreviewLayer) {
        let layerToAdd = layer
        
        layerToAdd.frame = cameraView.bounds
        cameraView.layer.addSublayer(layerToAdd)
    }
    
}

extension CameraViewController: ResultViewControllerDelegate {
    
    func getImage() -> UIImage {
        return camera.getCapturedFrame()
    }
    
}

