//
//  SettingsViewController.swift
//  MHacks9
//
//  Created by Avinash Singh on 26/04/17.
//  Copyright © 2017 DeeptanhuRyujiKenanAvi. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var timeTextField: UITextField!
    let datePickerView: UIDatePicker = UIDatePicker()
    var backgroundImage: UIImage?
    var seconds: Double?
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //datePickerView.isHidden = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func textFieldEditingDidBegin(_ sender: UITextField) {
        
        datePickerView.isHidden = false
        datePickerView.datePickerMode = UIDatePickerMode.countDownTimer
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(SettingsViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
        

    }
    
//    
//    @IBAction func textFieldEditing(_ sender: UITextField) {
//        
//        datePickerView.isHidden = false
//        datePickerView.datePickerMode = UIDatePickerMode.countDownTimer
//        sender.inputView = datePickerView
//        datePickerView.addTarget(self, action: #selector(SettingsViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
//        
//        
//    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func datePickerValueChanged(_ sender: UIDatePicker) {
        
        //datePickerView.isHidden = true
        //datePickerView.isHidden = false
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        //var seconds = UIDatePicker.countDownDuration
        seconds = sender.countDownDuration
        print(seconds!)
        UserDefaults.standard.set(seconds, forKey: "timeBefore")
        if(seconds != nil)
        {
        //dateTextField.text = dateFormatter.string(from: sender.datePicker.countDownDuration)
        let (h,m,s) = secondsToHoursMinutesSeconds(seconds: Int(seconds!))
        timeTextField.text = "\(h) hrs \(m) mins"
        }
        
    }

    @IBAction func selectTimeOnTap(_ sender: UITapGestureRecognizer) {
        timeTextField.resignFirstResponder()
        datePickerView.isHidden = true
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        //var seconds = UIDatePicker.countDownDuration
        seconds = datePickerView.countDownDuration
        print(seconds!)
        if(seconds != nil)
        {
        UserDefaults.standard.set(seconds, forKey: "timeBefore")
        //dateTextField.text = dateFormatter.string(from: sender.datePicker.countDownDuration)
        let (h,m,s) = secondsToHoursMinutesSeconds(seconds: Int(seconds!))
        timeTextField.text = "\(h) hrs \(m) mins"
        }
        
    }
    
    
    @IBAction func changeBackGroundImage(_ sender: Any) {
        
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(vc, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        let size = CGSize(width: 288, height: 288)
        let newImage = resize(image: editedImage, newSize: size)
        
        backgroundImage = newImage
        
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            dismiss(animated: true, completion: nil)
//            return
//        }
//        let managedContext = appDelegate.persistentContainer.viewContext
//        DispatchQueue.main.sync {
//            while managedContext == nil {
//                
//            }
//        }
//        let entity = NSEntityDescription.entity(forEntityName: "Background", in: managedContext)
//        
//        let back = NSManagedObject(entity: entity!, insertInto: managedContext)
//        let idata = UIImageJPEGRepresentation(newImage, 1)
//        back.setValue(idata, forKey: "background")
//        
//        do {
//            try managedContext.save()
//        }
//        catch let error as Error {
//            print(error.localizedDescription)
//        }
//        //*****************setBackGroundImage anf fire network request here********************
//        dismiss(animated: true, completion: nil)
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Background")
//        
//        do {
//            let data = try managedContext.fetch(fetchRequest) as? Data
//            if let data = data {
//                let backg = UIImage(data: data)
//                backgroundImageView.image = backg
//            }
//        }
//        catch let error as Error {
//            print(error.localizedDescription)
//        }
//        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    
    @IBAction func onTapLogout(_ sender: Any) {
        
        Facebook.sharedInstance.logOut()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
