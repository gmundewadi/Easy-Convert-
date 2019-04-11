//
//  ViewController.swift
//  Text Recognition Currency Exchange
//
//  Created by 王传正 on 2018/2/6.
//  Copyright © 2018年 Charlie. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    @IBOutlet weak var cameraView: UIImageView!
    @IBOutlet weak var frameView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var detectionSwitch: UISwitch!
    @IBOutlet weak var currencyLabel: UILabel!
    
    private let currency = Currency()
    private let imageProcessor = ImageProcessor()
    private let captureDevice = AVCaptureDevice.default(for: .video)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageProcessor.delegate = self
        imageProcessor.setupCaptureSession()
        addDetectionAreaRect()
        flashButton.isHidden = !captureDevice.hasTorch
        imageProcessor.shouldPerformTextDetection = detectionSwitch.isOn
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        imageProcessor.stopCaptureSession()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        imageProcessor.startCaptureSession()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func addDetectionAreaRect() {
        let area = CGRect(x: 16, y: 200, width: cameraView.frame.width - 32, height: 100)
        let rectView = UIView(frame: area)
        rectView.backgroundColor = UIColor.black
        rectView.layer.opacity = 0.25
        cameraView.addSubview(rectView)
    }
    
    @IBAction func toggleFlash(_ sender: UIButton) {
        try! captureDevice.lockForConfiguration()
        if flashButton.isSelected {
            captureDevice.torchMode = .off
            flashButton.isSelected = false
        } else {
            captureDevice.torchMode = .on
            flashButton.isSelected = true
        }
        captureDevice.unlockForConfiguration()
    }
    
    @IBAction func detectionSwitchPressed(_ sender: UISwitch) {
        imageProcessor.shouldPerformTextDetection = sender.isOn
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nc = segue.destination as! UINavigationController
        if segue.identifier == "Settings" {
            let vc = nc.topViewController as! SettingsViewController
            vc.delegate = self
        } else if segue.identifier == "SelectCurrency" {
            let vc = nc.topViewController as! SelectCurrencyViewController
            vc.delegate = self
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

extension MainViewController: ImageProcessorDelegate {
    
    func setupCameraView(with layer: AVCaptureVideoPreviewLayer) {
        let layerToAdd = layer
        layerToAdd.frame = cameraView.bounds
        cameraView.layer.addSublayer(layerToAdd)
    }
    
    func setFrameImage(to image: UIImage) {
        frameView.image = image
    }
    
    func setText(to recognizedText: String?) {
        if let text = recognizedText {
            textView.text = text
        }
    }
    
}

extension MainViewController: SelectCurrencyViewControllerDelegate {
    
    func setCurrency(code: String) {
        currencyLabel.text = "\(code): \(currency.exchangeRates![code]!)"
    }
    
}

extension MainViewController: SettingsViewControllerDelegate {
    
}
