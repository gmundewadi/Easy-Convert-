//
//  ImageProcessor.swift
//  Text Recognition Currency Exchange
//
//  Created by 王传正 on 2018/2/8.
//  Copyright © 2018年 Charlie. All rights reserved.
//

import UIKit
import AVFoundation
//import TesseractOCR

protocol ImageProcessorDelegate: class {
    func setupCameraView(with layer: AVCaptureVideoPreviewLayer)
    func setFrameImage(to image: UIImage)
    func setText(to recognizedText: String?)
}

class ImageProcessor: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate { //}, G8TesseractDelegate {
    
    private let captureSession = AVCaptureSession()
    private let captureDevice = AVCaptureDevice.default(for: .video)!
    private var capturedFrame = UIImage()
    //private let ocr = G8Tesseract(language: "eng")!
    let x = 43, y = 576, width = 915, height = 288
    var shouldPerformTextDetection = true
    
    weak var delegate: ImageProcessorDelegate?
    
    override init() {
        super.init()
        //ocr.delegate = self
        //ocr.charWhitelist = "0123456789."
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
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let outputImage = imageFromSampleBuffer(sampleBuffer: sampleBuffer)
        self.capturedFrame = cropImage(outputImage)
        if shouldPerformTextDetection {
            //ocr.image = capturedFrame
            //ocr.recognize()
//            DispatchQueue.main.async { [unowned self] in
//                if let image = self.ocr.image {
//                    self.delegate?.setFrameImage(to: image)
//                    self.delegate?.setText(to: self.ocr.recognizedText)
//                }
//            }
        } else {
            DispatchQueue.main.async { [unowned self] in
                self.delegate?.setFrameImage(to: self.capturedFrame)
                self.delegate?.setText(to: "Text Detection Off")
            }
        }
    }
    
    private func cropImage(_ image: UIImage) -> UIImage {
        let area = CGRect(x: y, y: x, width: height, height: width)
        let croppedCGImage = image.cgImage?.cropping(to: area)
        return UIImage(cgImage: croppedCGImage!, scale: 1.0, orientation: .right)
    }
    
    private func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> UIImage {
        
        let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        
        let ciImage = CIImage(cvPixelBuffer: imageBuffer).applyingFilter(
            "CIColorControls", parameters: [
            kCIInputSaturationKey: 0, kCIInputContrastKey: 32
        ])
        let ciContext = CIContext()
        let cgImage = ciContext.createCGImage(ciImage, from: ciImage.extent)
        let image = UIImage(cgImage: cgImage!, scale: 1.0, orientation: .right)
        
        return image
        
    }
    
}
