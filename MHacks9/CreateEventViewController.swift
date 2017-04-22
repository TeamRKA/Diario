//
//  CreateEventViewController.swift
//  MHacks9
//
//  Created by Ryuji Mano on 4/18/17.
//  Copyright © 2017 DeeptanhuRyujiKenanAvi. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UITextFieldDelegate, UISearchBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var date: Date?
    var image: UIImage?
    
    var locations: [NSDictionary]?
    
    var nearString = ""
    var searchString = ""
    var titleString = ""
    var dayString = ""
    var monthString = ""
    var yearString = ""
    var hourString = ""
    var minuteString = ""
    var descriptionString = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
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
        locations = []
        tableView.reloadData()
    }
    
    func setUpTitleCell(cell: DescriptionTableViewCell) -> DescriptionTableViewCell {
        cell.textView.tag = 0
        cell.textView.delegate = self
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func setUpDateCell(cell: DateTableViewCell) -> DateTableViewCell {
        cell.monthTextField.tag = 0
        cell.dayTextField.tag = 1
        cell.yearTextField.tag = 2
        
        cell.monthTextField.placeholder = "MM"
        cell.dayTextField.placeholder = "DD"
        cell.yearTextField.placeholder = "YYYY"
        
        cell.monthTextField.delegate = self
        cell.dayTextField.delegate = self
        cell.yearTextField.delegate = self
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func setUpTimeCell(cell: TimeTableViewCell) -> TimeTableViewCell {
        cell.hourTextField.tag = 3
        cell.minuteTextField.tag = 4
        
        cell.hourTextField.placeholder = "HH"
        cell.minuteTextField.placeholder = "MM"
        
        cell.hourTextField.delegate = self
        cell.minuteTextField.delegate = self
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func setUpDescriptionCell(cell: DescriptionTableViewCell) -> DescriptionTableViewCell {
        cell.textView.tag = 1
        cell.textView.delegate = self
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func setUpNearCell(cell: SearchTableViewCell) -> SearchTableViewCell {
        cell.searchField.tag = 5
        cell.searchField.delegate = self
        
        cell.searchField.text = nearString
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func setUpLocationSearchCell(cell: SearchTableViewCell) -> SearchTableViewCell {
        cell.searchField.tag = 6
        cell.searchField.delegate = self
        
        cell.searchField.text = searchString
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func setUpLocationCell(cell: LocationsTableViewCell, location: NSDictionary) -> LocationsTableViewCell {
        cell.venueLabel.text = location["name"] as? String
        let loc = location["location"] as! NSDictionary
        cell.locationLabel.text = (loc["city"] as? String)! + ", " + (loc["state"] as? String)!
        
        return cell
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 0 {
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
        else if textField.tag == 1 {
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
        else if textField.tag == 2 {
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
        else if textField.tag == 3 {
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
        else if textField.tag == 4 {
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
        else if textField.tag == 5 {
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
        else if textField.tag == 6 {
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
        if textField.tag == 0 {
            if let text = textField.text {
                if text != "" && text.characters.count < 2 {
                    textField.text = "0" + text
                    monthString = textField.text!
                }
            }
        }
        else if textField.tag == 1 {
            if let text = textField.text {
                if text != "" && text.characters.count < 2 {
                    textField.text = "0" + text
                    dayString = textField.text!
                }
            }
        }
        else if textField.tag == 2 {
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
        else if textField.tag == 3 {
            if let text = textField.text {
                if text != "" && text.characters.count < 2 {
                    textField.text = "0" + text
                    hourString = textField.text!
                }
            }
        }
        else if textField.tag == 4 {
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
        if textView.tag == 0 {
            if let text = textView.text {
                titleString = text
            }
        }
        else if textView.tag == 1 {
            if let text = textView.text {
                descriptionString = text
            }
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
