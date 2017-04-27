//
//  PersonalEventsViewController.swift
//  MHacks9
//
//  Created by Ryuji Mano on 4/18/17.
//  Copyright © 2017 DeeptanhuRyujiKenanAvi. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import SDWebImage
import MBProgressHUD

struct OrderedDict {
    var arr: [String] = []
    var dict: [String : Int] = [:]
    var dictArr: [[Int : NSDictionary]] = []
}

class PersonalEventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    var events: [NSDictionary] = []
    
    var days: OrderedDict!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        days = OrderedDict(arr: [], dict: [:], dictArr: [])
        
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("users").child(userID!).child("events").queryOrderedByValue().queryLimited(toFirst: 20).observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            if snapshot.value == nil {
                return
            }
            else {
                if let value = snapshot.value as? NSDictionary {
                    let queue = DispatchGroup()
                    for (i, val) in value {
                        queue.enter()
                        ref.child("events").child(i as! String).observeSingleEvent(of: .value, with: { (snap: FIRDataSnapshot) in
                            if snap.value == nil {
                                return
                            }
                            else {
                                if let value = snap.value as? NSDictionary {
                                    self.events.append(value)
                                }
                            }
                            queue.leave()
                        })
                        
                     
                    }
                    queue.notify(queue: .main, execute: {
                        let current = Date()
                        let calendar = Calendar.current
                        
                        let year = String(calendar.component(.year, from: current))
                        let month = String(calendar.component(.month, from: current))
                        let day = String(calendar.component(.day, from: current))
                        var idx = 0
                        var count = -1
                        for i in self.events {
                            if (i["date"] as! String) == "0\(month)-\(day)-\(year)" {
                                if self.days.dict["Today"] == nil {
                                    self.days.arr.append("Today")
                                    self.days.dict["Today"] = 1
                                    idx = 0
                                    self.days.dictArr.append([idx : i])
                                    print(1)
                                    //print(self.days.dictArr[count])
                                }
                                else {
                                    self.days.dict["Today"] = self.days.dict["Today"]! + 1
                                    self.days.dictArr[self.days.arr.index(of: "Today")!][self.days.dict["Today"]! - 1] = i
                                    print(2)
                                    //print(self.days.dictArr[count])
                                }
                            }
                            else {
                                if self.days.dict[i["date"] as! String] == nil {
                                    self.days.arr.append(i["date"] as! String)
                                    self.days.dict[i["date"] as! String] = 1
                                    idx = 0
                                    count += 1
                                    self.days.dictArr.append([idx : i])
                                    print(3)
                                    print(self.days.dictArr.count)
                                    print([idx: i])
                                    //print(self.days.dictArr[count])
                                }
                                else {
                                    print(i["date"] as! String)
                                    self.days.dict[i["date"] as! String]  = self.days.dict[i["date"] as! String]! + 1
                                    self.days.dictArr[self.days.arr.index(of: i["date"] as! String)!][self.days.dict[i["date"] as! String]! - 1] = i
                                    print(4)
                                    print(self.days.dictArr[self.days.arr.index(of: i["date"] as! String)!])
                                    //print(self.days.dictArr[count])
                                }
                            }
                            idx += 1
                        }
                        self.tableView.reloadData()
                        MBProgressHUD.hide(for: self.view, animated: true)
                    })
                    
                }
            }
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 550
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return days.arr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days.dict[days.arr[section]]!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! RemindersTableViewCell
        
        let event = days.dictArr[indexPath.section][indexPath.row]
        
        if let event = event {
            cell.titleLabel.text = event["title"] as! String
            cell.locationLabel.text = event["location"] as! String
            cell.timeLabel.text = event["time"] as! String
            cell.shortDescriptionLabel.text = event["description"] as! String
            cell.fullDescriptionLabel.text = event["description"] as! String
            
            cell.second?.isHidden = true
            
            if let lng = event["longitude"] as? Double {
                let lat = event["latitude"] as! Double
                
                cell.mapView.delegate = self
                cell.mapView.isUserInteractionEnabled = false
                
                cell.goToLocation(location: CLLocation(latitude: lat, longitude: lng))
                cell.addAnnotation(location: CLLocation(latitude: lat, longitude: lng))
                
                
                cell.third?.isHidden = true
            }
            else {
                cell.mapExists = false
                cell.third?.isHidden = true
            }
            if let urlString = event["eventPhoto"] as? String {
                let url = URL(string: urlString)
                cell.sd_setShowActivityIndicatorView(true)
                cell.sd_setIndicatorStyle(.gray)
                cell.eventImageView.sd_setImage(with: url)
                cell.fifth?.isHidden = true
                cell.fourth?.isHidden = true
            }
            else {
                cell.photoExists = false
                cell.fifth?.isHidden = true
                cell.fourth?.isHidden = true
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! RemindersTableViewCell
        tableView.deselectRow(at: indexPath, animated: true)
        if cell.isCollapsed {
            if cell.mapExists {
                cell.fourth?.isHidden = false
                cell.fifth?.isHidden = false
            }
            if cell.photoExists {
                cell.third?.isHidden = false
            }
            cell.second?.isHidden = false
            cell.first?.isHidden = true
        }
        else {
            if cell.mapExists {
                cell.fourth?.isHidden = true
                cell.fifth?.isHidden = true
            }
            if cell.photoExists {
                cell.third?.isHidden = true
            }
            cell.second?.isHidden = true
            cell.first?.isHidden = false
        }
        cell.isCollapsed = !cell.isCollapsed
        DispatchQueue.main.async {
        tableView.beginUpdates()
        tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return days.arr[section]
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        tableView.headerView(forSection: section)?.backgroundColor = .clear
        return tableView.headerView(forSection: section)
    }
    
//    func goToLocation(location: CLLocation, cell: RemindersTableViewCell) -> RemindersTableViewCell {
//        let span = MKCoordinateSpanMake(0.01, 0.01)
//        let region = MKCoordinateRegionMake(location.coordinate, span)
//        cell.mapView.setRegion(region, animated: false)
//        return cell
//    }
//    
//    func addAnnotation(location: CLLocation, cell: RemindersTableViewCell) -> RemindersTableViewCell {
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = location.coordinate
//        cell.mapView.addAnnotation(annotation)
//        return cell
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
