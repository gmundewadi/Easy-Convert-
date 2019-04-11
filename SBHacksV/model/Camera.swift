//
//  Camera.swift
//  OCRCurrencyConverter
//
//  Created by 王传正 on 2019/1/11.
//  Copyright © 2019 zcgr. All rights reserved.
//

import UIKit
import AVFoundation

protocol CameraDelegate: class {
    func setupCameraView(with layer: AVCaptureVideoPreviewLayer)
}

class Camera: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    private let captureSession = AVCaptureSession()
    private let captureDevice = AVCaptureDevice.default(for: .video)!
    private var capturedFrame: UIImage?
    
    weak var delegate: CameraDelegate?
    
    func getCapturedFrame() -> UIImage {
        return capturedFrame!
    }
    
    func setupCaptureSession() {
        
        let input = try! AVCaptureDeviceInput(device: captureDevice)
        let output = AVCaptureVideoDataOutput()
        output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "VideoQueue"))
        let connection = output.connection(with: .video)
        connection?.videoOrientation = .portrait
        captureSession.addInput(input)
        captureSession.addOutput(output)
        
        let layer = AVCaptureVideoPreviewLayer(session: captureSession)
        delegate?.setupCameraView(with: layer)
        
        captureSession.startRunning()
        
    }
    
    func startCaptureSession() { captureSession.startRunning() }
    func stopCaptureSession() { captureSession.stopRunning() }
    
    private func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let outputImage = imageFromSampleBuffer(sampleBuffer: sampleBuffer)
        capturedFrame = outputImage
    }
    
    private func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> UIImage {
        
        //guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        let ciImage = CIImage(cvPixelBuffer: imageBuffer!)
        let image = UIImage(ciImage: ciImage)
        
        return image
        
    }
    
}
