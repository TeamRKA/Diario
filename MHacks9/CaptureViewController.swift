//
//  CaptureViewController.swift
//  MHacks9
//
//  Created by Kenan Dominic on 3/25/17.
//  Copyright © 2017 DeeptanhuRyujiKenanAvi. All rights reserved.
//

import UIKit
import CameraManager

class CaptureViewController: UIViewController,  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  var image: UIImage?
  let cameraManager = CameraManager()
  
  @IBOutlet weak var cameraView: UIView!
    
    var date: Date?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    let transparentPixel = UIImage(named: "clear")
    self.tabBarController?.tabBar.backgroundImage = transparentPixel
    self.tabBarController?.tabBar.shadowImage = transparentPixel
    self.tabBarController?.tabBar.isTranslucent = true
    
    cameraManager.addPreviewLayerToView(self.cameraView)
    cameraManager.cameraDevice = .back
    cameraManager.cameraOutputMode = .videoOnly
    cameraManager.cameraOutputQuality = .medium
    cameraManager.flashMode = .auto
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func onCapture(_ sender: Any) {
    self.cameraManager.capturePictureWithCompletion { (image: UIImage?, error: NSError?) in
      if let image = image {
        self.image = image
        GoogleCloudVisionAPI.getText(from: image)
        //let date = parseText.getDate(input: GoogleCloudVisionAPI.recognizedText)
        let date = self.callParseTextLinebyLine(input: GoogleCloudVisionAPI.recognizedText)
        if ((date) != nil){
            self.date = date
          self.performSegue(withIdentifier: "captureSegue", sender: nil)
        }
        else{
          let alert = UIAlertController(title: "An Error Occurred", message: "An error occurred when looking for a date. Please try again.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            self.show(alert, sender: nil)
        }
      }
      
    }
  }
  
  //MARK: - Private
  private func callParseTextLinebyLine(input: String) -> Date?{
    let textLines = input.components(separatedBy: .newlines)
    for line in textLines{
      if let date = parseText.sharedInstance.getDate(input: line) {
        return date
      }
    }
    return nil
  }
  
  
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! UINavigationController
        let vc = destination.topViewController as! CreateViewController
        vc.date = self.date
   }
   
    @IBAction func onSwipeUp(_ sender: UISwipeGestureRecognizer) {
        
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        //let size = CGSize(width: 288, height: 288)
        //let newImage = resize(image: editedImage, newSize: size)
        
        //if let image = editedImage {
            self.image = editedImage
            GoogleCloudVisionAPI.getText(from: image!)
            //let date = parseText.getDate(input: GoogleCloudVisionAPI.recognizedText)
            let date = self.callParseTextLinebyLine(input: GoogleCloudVisionAPI.recognizedText)
            if ((date) != nil){
                self.date = date
                self.performSegue(withIdentifier: "captureSegue", sender: nil)
            }
            else{
                let alert = UIAlertController(title: "An Error Occurred", message: "An error occurred when looking for a date. Please try again.", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(action)
                self.show(alert, sender: nil)
            }
        
        // Do something with the images (based on your use case
        // Dismiss UIImagePickerController to go back to your original view controller
      
    }
  
}
