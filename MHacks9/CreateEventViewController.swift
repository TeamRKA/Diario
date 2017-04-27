//
//  CreateEventViewController.swift
//  MHacks9
//
//  Created by Ryuji Mano on 4/18/17.
//  Copyright © 2017 DeeptanhuRyujiKenanAvi. All rights reserved.
//

import UIKit
import Firebase

class CreateEventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UITextFieldDelegate, UISearchBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var date: Date?
    var timestamp: Double?
    var reverse: Double?
    var image: UIImage?
    
    var locations: [NSDictionary]?
    
    @IBOutlet weak var backgroundImage: UIImageView!
    var nearString = ""
    var searchString = ""
    var titleString = ""
    var dayString = ""
    var monthString = ""
    var yearString = ""
    var hourString = ""
    var minuteString = ""
    var descriptionString = ""
    var longitude = 0.0
    var latitude = 0.0
    
    var textTag = -1
    var editingTextField: UITextField?
    var editingTextView: UITextView?
    
    @IBOutlet var toolBar: UIToolbar!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let date = self.date {
            var dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-yyyy-MM HH:mm:ss"
            
            let dateString = dateFormatter.string(from: date)
            
            let arr2 = dateString.components(separatedBy: " ")
            let arr3 = arr2[1].components(separatedBy: ":")
            let arr = arr2[0].components(separatedBy: "-")
            
            monthString = arr[2]
            dayString = arr[0]
            yearString = arr[1]
            
            hourString = arr3[0]
            minuteString = arr3[1]
            
            timestamp = date.timeIntervalSince1970
            
            reverse = timestamp! * -1.0
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 6 {
            return locations?.count ?? 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Title"
        }
        else if section == 1 {
            return "Date"
        }
        else if section == 2 {
            return "Time"
        }
        else if section == 3 {
            return "Description"
        }
        else if section == 4 {
            return "Near"
        }
        else if section == 5 {
            return "Location"
        }
        return nil
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath) as! DescriptionTableViewCell
            return setUpTitleCell(cell: cell)
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as! DateTableViewCell
            return setUpDateCell(cell: cell)
        }
        else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "timeCell", for: indexPath) as! TimeTableViewCell
            return setUpTimeCell(cell: cell)
        }
        else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath) as! DescriptionTableViewCell
            return setUpDescriptionCell(cell: cell)
        }
        else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell
            return setUpNearCell(cell: cell)
        }
        else if indexPath.section == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell
            return setUpLocationSearchCell(cell: cell)
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! LocationsTableViewCell
            let location = locations?[indexPath.row]
            return setUpLocationCell(cell: cell, location: location!)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section < 6 {
            tableView.deselectRow(at: indexPath, animated: false)
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)
        let location = locations?[indexPath.row]
        searchString = location?["name"] as! String
        let loc = location?["location"] as! NSDictionary
        nearString = "\(loc["city"] as! String), \(loc["state"] as! String)"
        latitude = loc["lat"] as! Double
        longitude = loc["lng"] as! Double
        locations = []
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        
        if let textLabel = header.textLabel {
            textLabel.font = textLabel.font.withSize(16)
        }
    }
    
    func setUpTitleCell(cell: DescriptionTableViewCell) -> DescriptionTableViewCell {
        cell.textView.tag = 1
        cell.textView.delegate = self
        
        cell.textView.layer.borderColor = UIColor.lightGray.cgColor
        cell.textView.layer.borderWidth = 1
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func setUpDateCell(cell: DateTableViewCell) -> DateTableViewCell {
        cell.monthTextField.tag = 2
        cell.dayTextField.tag = 3
        cell.yearTextField.tag = 4
        
        if monthString == "" {
            cell.monthTextField.placeholder = "MM"
        }
        else  {
            cell.monthTextField.text = monthString
        }
        
        if dayString == "" {
            cell.dayTextField.placeholder = "DD"
        }
        else {
            cell.dayTextField.text = dayString
        }
        
        if yearString == "" {
            cell.yearTextField.placeholder = "YYYY"
        }
        else {
            cell.yearTextField.text = yearString
        }
        
        cell.monthTextField.delegate = self
        cell.dayTextField.delegate = self
        cell.yearTextField.delegate = self
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func setUpTimeCell(cell: TimeTableViewCell) -> TimeTableViewCell {
        cell.hourTextField.tag = 5
        cell.minuteTextField.tag = 6
        
        if hourString == "" {
            cell.hourTextField.placeholder = "HH"
        }
        else {
            cell.hourTextField.text = hourString
        }
        
        if minuteString == "" {
            cell.minuteTextField.placeholder = "MM"
        }
        else {
            cell.minuteTextField.text = minuteString
        }
        
        
        cell.hourTextField.delegate = self
        cell.minuteTextField.delegate = self
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func setUpDescriptionCell(cell: DescriptionTableViewCell) -> DescriptionTableViewCell {
        cell.textView.tag = 7
        cell.textView.delegate = self
        
        cell.selectionStyle = .none
        
        cell.textView.layer.borderColor = UIColor.lightGray.cgColor
        cell.textView.layer.borderWidth = 1
        
        return cell
    }
    
    func setUpNearCell(cell: SearchTableViewCell) -> SearchTableViewCell {
        cell.searchField.tag = 8
        cell.searchField.delegate = self
        
        cell.searchField.text = nearString
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func setUpLocationSearchCell(cell: SearchTableViewCell) -> SearchTableViewCell {
        cell.searchField.tag = 9
        cell.searchField.delegate = self
        
        cell.searchField.text = searchString
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func setUpLocationCell(cell: LocationsTableViewCell, location: NSDictionary) -> LocationsTableViewCell {
        cell.venueLabel.text = location["name"] as? String
        let loc = location["location"] as? NSDictionary
        if let loc = loc {
            guard let city = loc["city"] as? String, let state = loc["state"] as? String else {
                return cell
            }
            cell.locationLabel.text = city + ", " + state
        }
        
        return cell
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 2 {
            let monthString = NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string)
            if let monthString = Int(monthString) {
                if monthString > 12 {
                    return false
                }
            }
            self.monthString = monthString
            if let text = textField.text {
                return !(text.characters.count > 1 && string.characters.count > range.length)
            }
        }
        else if textField.tag == 3 {
            let dayString = NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string)
            if let dayString = Int(dayString) {
                if dayString > 31 {
                    return false
                }
            }
            self.dayString = dayString
            if let text = textField.text {
                return !(text.characters.count > 1 && string.characters.count > range.length)
            }
        }
        else if textField.tag == 4 {
            let yearString = NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string)
            if let text = textField.text {
                if !(text.characters.count > 3 && string.characters.count > range.length) {
                    self.yearString = yearString
                    return true
                }
                else {
                    return false
                }
            }
        }
        else if textField.tag == 5 {
            let hourString = NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string)
            if let hourString = Int(hourString) {
                if hourString > 23 {
                    return false
                }
            }
            self.hourString = hourString
            if let text = textField.text {
                return !(text.characters.count > 1 && string.characters.count > range.length)
            }
        }
        else if textField.tag == 6 {
            let minuteString = NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string)
            if let minuteString = Int(minuteString) {
                if minuteString > 59 {
                    return false
                }
            }
            self.minuteString = minuteString
            if let text = textField.text {
                return !(text.characters.count > 1 && string.characters.count > range.length)
            }
        }
        else if textField.tag == 8 {
            nearString = NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string)
            if searchString == "" {
                return true
            }
            FourSquareAPI.shared.getVenues(near: nearString, searchText: searchString, success: { (response: [NSDictionary]) in
                self.locations = response
                self.tableView.reloadSections([6], with: .automatic)
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
        }
        else if textField.tag == 9 {
            searchString = NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string)
            if nearString == "" {
                return true
            }
            FourSquareAPI.shared.getVenues(near: nearString, searchText: searchString, success: { (response: [NSDictionary]) in
                self.locations = response
                self.tableView.reloadSections([6], with: .automatic)
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
        }
        
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 2 {
            if let text = textField.text {
                if text != "" && text.characters.count < 2 {
                    textField.text = "0" + text
                    monthString = textField.text!
                }
            }
        }
        else if textField.tag == 3 {
            if let text = textField.text {
                if text != "" && text.characters.count < 2 {
                    textField.text = "0" + text
                    dayString = textField.text!
                }
            }
        }
        else if textField.tag == 4 {
            if let text = textField.text {
                let len = text.characters.count
                if text != "" && len < 4 {
                    if len == 1 {
                        textField.text = "000" + text
                    }
                    else if len == 2 {
                        textField.text = "00" + text
                    }
                    else if len == 3 {
                        textField.text = "0" + text
                    }
                    yearString = textField.text!
                }
            }
        }
        else if textField.tag == 5 {
            if let text = textField.text {
                if text != "" && text.characters.count < 2 {
                    textField.text = "0" + text
                    hourString = textField.text!
                }
            }
        }
        else if textField.tag == 6 {
            if let text = textField.text {
                if text != "" && text.characters.count < 2 {
                    textField.text = "0" + text
                    minuteString = textField.text!
                }
            }
        }
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        let contentOffset = tableView.contentOffset
        UIView.setAnimationsEnabled(false)
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        self.tableView.setContentOffset(contentOffset, animated: false)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.tag == 1 {
            if let text = textView.text {
                titleString = text
            }
        }
        else if textView.tag == 7 {
            if let text = textView.text {
                descriptionString = text
            }
        }
    }
    
    
    @IBAction func tapControl(_ sender: UISegmentedControl) {
        var nextTag: Int!
        let index = sender.selectedSegmentIndex
        sender.selectedSegmentIndex = UISegmentedControlNoSegment
        if let textField = editingTextField {
            nextTag = textField.tag + (index == 0 ? -1 : 1)
            print(nextTag)
            let nextResponder = textField.superview?.superview?.superview?.viewWithTag(nextTag) as UIResponder!
            
            if nextResponder == nil {
                textField.resignFirstResponder()
                editingTextField = nil
                
            }
            else {
                editingTextField = nil
                nextResponder?.becomeFirstResponder()
                
            }
        }
        else if let textView = editingTextView {
            nextTag = textView.tag + (index == 0 ? -1 : 1)
            print(nextTag)
            let nextResponder = textView.superview?.superview?.superview?.viewWithTag(nextTag) as UIResponder!
            
            if nextResponder == nil {
                textView.resignFirstResponder()
                editingTextView = nil
            }
            else {
                editingTextView = nil
                nextResponder?.becomeFirstResponder()
            }
        }
    }
    
    
    @IBAction func finishTyping(_ sender: Any) {
        if let text = editingTextField {
            text.resignFirstResponder()
        }
        else if let text = editingTextView {
            text.resignFirstResponder()
        }
        editingTextField = nil
        editingTextView = nil
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.inputAccessoryView = toolBar
        textTag = textField.tag
        editingTextField = textField
        editingTextView = nil
        return true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.inputAccessoryView = toolBar
        textTag = textView.tag
        editingTextView = textView
        editingTextField = nil
        return true
    }
    
    func keyboardWillShow(notification: NSNotification) {
        var userInfo = notification.userInfo
        var keyboardFrame = (userInfo?[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset = self.tableView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.tableView.contentInset = contentInset
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        self.tableView.contentInset = contentInset
    }
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSave(_ sender: Any) {
        if titleString == "" || monthString == "" || dayString == "" || yearString == "" || hourString == "" || minuteString == "" || searchString == "" {
            return
        }
        var ref: FIRDatabaseReference!
        let user = FIRAuth.auth()?.currentUser
        ref = FIRDatabase.database().reference()
        
        let autoID: String!
        
        let date = "\(monthString)-\(dayString)-\(yearString)"
        let time = "\(hourString):\(minuteString)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm:ss ZZZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let eventDate = dateFormatter.date(from: date + " " + time + ":00 UTC")
        
        timestamp = eventDate?.timeIntervalSince1970
        reverse = timestamp! * -1.0
        
        let dict = ["title" : titleString, "date" : date, "time" : time, "description" : descriptionString, "near" : nearString, "location" : searchString, "longitude" : longitude, "latitude" : latitude, "eventPhoto" : "", "timestamp" : timestamp, "reverseTimeStamp" : reverse] as [String : Any]
        let dataRef = ref.child("events").childByAutoId()
        dataRef.setValue(dict)
        
        autoID = dataRef.key
        
        ref.child("users").child(user!.uid).child("events").child(autoID).setValue(reverse)
        
        if let image = self.image {
            var data = Data()
            data = UIImageJPEGRepresentation(image, 0.8)!
            
            let metadata = FIRStorageMetadata()
            
            metadata.contentType = "image/jpeg"
            
            let storageRef = FIRStorage.storage().reference().child(user!.uid + "/" + autoID)
            
            storageRef.put(data, metadata: metadata, completion: { (meta: FIRStorageMetadata?, error: Error?) in
                if let error = error {
                    print(error.localizedDescription)
                }
                else {
                    let downloadURL = meta!.downloadURL()!.absoluteString
                    dataRef.child("eventPhoto").setValue(downloadURL)
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
            })
        }
        else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        }
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
