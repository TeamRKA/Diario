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
    
    var nearString = "chicago"

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 5 {
            return 1 + (locations?.count ?? 0)
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
        return ""
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
        else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell
                return setUpLocationSearchCell(cell: cell)
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! LocationsTableViewCell
            let location = locations?[indexPath.row - 1]
            return setUpLocationCell(cell: cell, location: location!)
        }
    }
    
    func setUpTitleCell(cell: DescriptionTableViewCell) -> DescriptionTableViewCell {
        cell.textView.tag = 0
        cell.textView.delegate = self
        
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
        
        return cell
    }
    
    func setUpTimeCell(cell: TimeTableViewCell) -> TimeTableViewCell {
        cell.hourTextField.tag = 3
        cell.minuteTextField.tag = 4
        
        cell.hourTextField.placeholder = "HH"
        cell.minuteTextField.placeholder = "MM"
        
        cell.hourTextField.delegate = self
        cell.minuteTextField.delegate = self
        
        return cell
    }
    
    func setUpDescriptionCell(cell: DescriptionTableViewCell) -> DescriptionTableViewCell {
        cell.textView.tag = 1
        cell.textView.delegate = self
        
        return cell
    }
    
    func setUpNearCell(cell: SearchTableViewCell) -> SearchTableViewCell {
        cell.searchField.tag = 5
        cell.searchField.delegate = self
        
        return cell
    }
    
    func setUpLocationSearchCell(cell: SearchTableViewCell) -> SearchTableViewCell {
        cell.searchField.tag = 6
        cell.searchField.delegate = self
        
//        FourSquareAPI.shared.getVenues(near: "Chicago, Il", searchText: "sears", success: { (dict: [NSDictionary]) in
//            self.locations = dict
//            
//            self.tableView.reloadData()
//            
//        }) { (error: Error) in
//            print(error.localizedDescription)
//        }
        return cell
    }
    
    func setUpLocationCell(cell: LocationsTableViewCell, location: NSDictionary) -> LocationsTableViewCell {
        cell.venueLabel.text = location["name"] as? String
        let loc = location["location"] as! NSDictionary
        cell.locationLabel.text = (loc["city"] as? String)! + ", " + (loc["state"] as? String)!
        
        return cell
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField.tag == 5 {
//            nearString = textField.text ?? ""
//        }
//    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 6 {
            if nearString == "" {
                return true
            }
            let newString = NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string)
            FourSquareAPI.shared.getVenues(near: nearString, searchText: newString, success: { (response: [NSDictionary]) in
                self.locations = response
                self.tableView.reloadData()
                textField.resignFirstResponder()
                textField.becomeFirstResponder()
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
        }
        
        return true
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
