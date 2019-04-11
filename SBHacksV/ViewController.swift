//
//  ViewController.swift
//  CropImg
//
//  Created by Duncan Champney on 3/24/15.
//  Copyright (c) 2015 Duncan Champney. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import MobileCoreServices
import TesseractOCR

//-------------------------------------------------------------------------------------------------------
let tesseract:G8Tesseract  = G8Tesseract(language: "eng")!

func loadShutterSoundPlayer() -> AVAudioPlayer?
{
  let theMainBundle = Bundle.main
  let filename = "Shutter sound"
  let fileType = "mp3"
  let soundfilePath: String? = theMainBundle.path(forResource: filename,
    ofType: fileType,
    inDirectory: nil)
  if soundfilePath == nil
  {
    return nil
  }
  //println("soundfilePath = \(soundfilePath)")
  let fileURL = URL(fileURLWithPath: soundfilePath!)
  var error: NSError?
  let result: AVAudioPlayer?
  do {
    result = try AVAudioPlayer(contentsOf: fileURL)
  } catch let error1 as NSError {
    error = error1
    result = nil
  }
  if let requiredErr = error
  {
    print("AVAudioPlayer.init failed with error \(requiredErr.debugDescription)")
  }
  if result?.settings != nil
  {
    //println("soundplayer.settings = \(settings)")
  }
  result?.prepareToPlay()
  return result
}

//-------------------------------------------------------------------------------------------------------



class ViewController:
  UIViewController,
  CroppableImageViewDelegateProtocol,
  UIImagePickerControllerDelegate,
  UINavigationControllerDelegate,
  UIPopoverControllerDelegate, G8TesseractDelegate
{
    
    let currObj = Currency();
  @IBOutlet weak var whiteView: UIView!
  @IBOutlet weak var cropButton: UIButton!
  @IBOutlet weak var cropView: CroppableImageView!
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var resultOutlet: UILabel!

    
    var shutterSoundPlayer = loadShutterSoundPlayer()
  
  override func viewDidAppear(_ animated: Bool) {
//    let status = PHPhotoLibrary.authorizationStatus()
//    if status != .authorized {
//      PHPhotoLibrary.requestAuthorization() {
//        status in
//      }
//    }
    print("appearing... \(Currency.sharedCurr.currHomeCode) \(Currency.sharedCurr.currGuestCode)")
    
    result.text = "\(Currency.sharedCurr.currHomeCode): \(Currency.sharedCurr.storedHome)"
    resultOutlet.text = "\(Currency.sharedCurr.currGuestCode): \(Currency.sharedCurr.storedGuest)"
    
  }
override func viewDidLoad()
{
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  enum ImageSource: Int
  {
    case camera = 1
    case photoLibrary
  }
  
  func pickImageFromSource(
    _ theImageSource: ImageSource,
    fromButton: UIButton)
  {
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.allowsEditing = true;
    
    switch theImageSource
    {
    case .camera:
        imagePicker.mediaTypes = [kUTTypeImage as String]
      print("User chose take new pic button")
      imagePicker.sourceType = UIImagePickerController.SourceType.camera
      imagePicker.cameraDevice = UIImagePickerController.CameraDevice.rear;
    case .photoLibrary:
      print("User chose select pic button")
      imagePicker.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
    }
    if UIDevice.current.userInterfaceIdiom == .pad
    {
      if theImageSource == ImageSource.camera
      {
      self.present(
        imagePicker,
        animated: true)
        {
          //println("In image picker completion block")
        }
      }
      else
      {
        self.present(
          imagePicker,
          animated: true)
          {
            //println("In image picker completion block")
        }
//        //Import from library on iPad
//        let pickPhotoPopover = UIPopoverController.init(contentViewController: imagePicker)
//        //pickPhotoPopover.delegate = self
//        let buttonRect = fromButton.convertRect(
//          fromButton.bounds,
//          toView: self.view.window?.rootViewController?.view)
//        imagePicker.delegate = self;
//        pickPhotoPopover.presentPopoverFromRect(
//          buttonRect,
//          inView: self.view,
//          permittedArrowDirections: UIPopoverArrowDirection.Any,
//          animated: true)
//        
      }
    }
    else
    {
      self.present(
        imagePicker,
        animated: true)
        {
          print("In image picker completion block")
      }
      
    }
  }
  
  func saveImageToCameraRoll(_ image: UIImage) {
     PHPhotoLibrary.shared().performChanges({
     PHAssetChangeRequest.creationRequestForAsset(from: image)
     }, completionHandler: { success, error in
     if success {
     // Saved successfully!
     }
     else if let error = error {
      print("Save failed with error " + String(describing: error))
     }
     else {
     }
     })

  }
  //-------------------------------------------------------------------------------------------------------
  // MARK: - IBAction methods -
  //-------------------------------------------------------------------------------------------------------

  @IBAction func handleSelectImgButton(_ sender: UIButton)
  {
    /*See if the current device has a camera. (I don't think any device that runs iOS 8 lacks a camera,
    But the simulator doesn't offer a camera, so this prevents the
    "Take a new picture" button from crashing the simulator.
    */
    let deviceHasCamera: Bool = UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
    print("In \(#function)")
    
    //Create an alert controller that asks the user what type of image to choose.
    let anActionSheet =  UIAlertController(title: "Pick Image Source",
      message: nil,
      preferredStyle: UIAlertController.Style.actionSheet)
    
    
    //Offer the option to re-load the starting sample image
    let sampleAction = UIAlertAction(
      title:"Load Sample Image",
      style: UIAlertAction.Style.default,
      handler:
      {
        (alert: UIAlertAction)  in
        self.cropView.imageToCrop = UIImage(named: "test")
      }
    )
    
    //If the current device has a camera, add a "Take a New Picture" button
    var takePicAction: UIAlertAction? = nil
    if deviceHasCamera
    {
      takePicAction = UIAlertAction(
        title: "Take a New Picture",
        style: UIAlertAction.Style.default,
        handler:
        {
          (alert: UIAlertAction)  in
          self.pickImageFromSource(
            ImageSource.camera,
            fromButton: sender)
        }
      )
    }
    
    //Allow the user to selecxt an amage from their photo library
    let selectPicAction = UIAlertAction(
      title:"Select Picture from library",
      style: UIAlertAction.Style.default,
      handler:
      {
        (alert: UIAlertAction)  in
        self.pickImageFromSource(
          ImageSource.photoLibrary,
          fromButton: sender)
      }
    )
    
    let cancelAction = UIAlertAction(
      title:"Cancel",
      style: UIAlertAction.Style.cancel,
      handler:
      {
        (alert: UIAlertAction)  in
        print("User chose cancel button")
      }
    )
    anActionSheet.addAction(sampleAction)
    
    if let requiredtakePicAction = takePicAction
    {
      anActionSheet.addAction(requiredtakePicAction)
    }
    anActionSheet.addAction(selectPicAction)
    anActionSheet.addAction(cancelAction)
    
    let popover = anActionSheet.popoverPresentationController
    popover?.sourceView = sender
    popover?.sourceRect = sender.bounds;
    
    self.present(anActionSheet, animated: true)
      {
        //println("In action sheet completion block")
    }
  }
  
  
    
    @IBAction func handleCropButton(_ sender: UIButton)
  {
    let sharedModel = Currency.sharedCurr;
//    var aFloat: Float
//    aFloat = (sender.currentTitle! as NSString).floatValue
    //println("Button title = \(buttonTitle)")
    if let croppedImage = cropView.croppedImage()
    {
      self.whiteView.isHidden = false
      delay(0)
        {
          // self.shutterSoundPlayer?.play()
        
            // tessoract
            tesseract.delegate = self
            tesseract.charWhitelist = "0123456789."
            
            self.cropView.imageToCrop = croppedImage;
            tesseract.image = croppedImage
            
            tesseract.recognize()
            // print result

            var filteredMessage : String = tesseract.recognizedText ?? "WRONG"
            var len = 0;
            while(filteredMessage[len] != ".") {
                if(len==filteredMessage.count) {
                    break;
                }
                len += 1
            }
            filteredMessage = String(filteredMessage.prefix(len+3));
            print("working:.. \(filteredMessage)")

            let sourcePrice = Double(filteredMessage)
            
            self.result.text = "\(Currency.sharedCurr.currHomeCode): \((filteredMessage) ?? "Error, check console output")"
            
//            print("rates size: \(self.currObj.rates?.count)")
//            print("homecODE \(Currency.sharedCurr.currHomeCode)");
//            print("GUESTcODE \(Currency.sharedCurr.currGuestCode)");
            let firstVal = self.currObj.rates?[Currency.sharedCurr.currHomeCode];
            let secondVal = self.currObj.rates?[Currency.sharedCurr.currGuestCode];
            
            let result = sourcePrice! * secondVal!/firstVal!
            self.resultOutlet.text = "\(Currency.sharedCurr.currGuestCode): \(result)"
            
            Currency.sharedCurr.storedGuest = "\(result)";
            Currency.sharedCurr.storedHome = filteredMessage;
            
          // self.saveImageToCameraRoll(croppedImage)
          //UIImageWriteToSavedPhotosAlbum(croppedImage, nil, nil, nil);
          
          delay(0.2)
            {
              self.whiteView.isHidden = true
              self.shutterSoundPlayer?.prepareToPlay()
          }
      }
      
      
      //The code below saves the cropped image to a file in the user's documents directory.
      /*------------------------
      let jpegData = UIImageJPEGRepresentation(croppedImage, 0.9)
      let documentsPath:String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,
      NSSearchPathDomainMask.UserDomainMask,
      true).last as String
      let filename = "croppedImage.jpg"
      var filePath = documentsPath.stringByAppendingPathComponent(filename)
      if (jpegData.writeToFile(filePath, atomically: true))
      {
      println("Saved image to path \(filePath)")
      }
      else
      {
      println("Error saving file")
      }
      */
    }
    
    
  }

  //-------------------------------------------------------------------------------------------------------
  // MARK: - CroppableImageViewDelegateProtocol methods -
  //-------------------------------------------------------------------------------------------------------

  func haveValidCropRect(_ haveValidCropRect:Bool)
  {
    //println("In haveValidCropRect. Value = \(haveValidCropRect)")
    cropButton.isEnabled = haveValidCropRect
  }
  //-------------------------------------------------------------------------------------------------------
  // MARK: - UIImagePickerControllerDelegate methods -
  //-------------------------------------------------------------------------------------------------------
    
func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
    {
        picker.dismiss(animated: true, completion: nil)
        cropView.imageToCrop = image
        result.text = "\(Currency.sharedCurr.currHomeCode):"
        resultOutlet.text = "\(Currency.sharedCurr.currGuestCode):"
    }
}
  

  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
  {
    print("In \(#function)")
    picker.dismiss(animated: true, completion: nil)
  }
}

extension String {
    subscript(index: Int) -> Character {
        get {
            return self[self.index(startIndex, offsetBy: index)]
        }
        set {
            let i = self.index(startIndex, offsetBy: index)
            self.replaceSubrange(i...i, with: String(newValue))
        }
    }
}
