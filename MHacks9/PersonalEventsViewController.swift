//
//  PersonalEventsViewController.swift
//  MHacks9
//
//  Created by Ryuji Mano on 4/18/17.
//  Copyright © 2017 DeeptanhuRyujiKenanAvi. All rights reserved.
//

import UIKit
import Firebase

struct OrderedDict {
    var arr: [String] = []
    var dict: [String : Int] = [:]
    var dictArr: [[Int : NSDictionary]] = []
}

class PersonalEventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var events: [NSDictionary] = []
    
    var days: OrderedDict!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        days = OrderedDict(arr: [], dict: [:], dictArr: [])
        
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        
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
                            if (i["date"] as! String) == "\(month)-\(day)-\(year)" {
                                if self.days.dict["Today"] == nil {
                                    self.days.arr.append("Today")
                                    self.days.dict["Today"] = 1
                                    idx = 0
                                    count += 1
                                    self.days.dictArr.append([idx : i])
                                    print(1)
                                    print(self.days.dictArr[count])
                                }
                                else {
                                    self.days.dict["Today"] = self.days.dict["Today"]! + 1
                                    self.days.dictArr[count][idx] = i
                                    print(2)
                                    print(self.days.dictArr[count])
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
                                    print(self.days.dictArr[count])
                                }
                                else {
                                    self.days.dict[i["date"] as! String]  = self.days.dict[i["date"] as! String]! + 1
                                    self.days.dictArr[count][idx] = i
                                    print(4)
                                    print(self.days.dictArr[count])
                                }
                            }
                            idx += 1
                        }
                        self.tableView.reloadData()
                    })
                    
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! RemindersTableViewCell
        
        print("\(indexPath.section) \(indexPath.row)")
        let event = days.dictArr[indexPath.section][indexPath.row]
        print(event)
        if let event = event {
            cell.titleLabel.text = event["title"] as! String
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        tableView.headerView(forSection: section)?.textLabel?.text = days.arr[section]
        return tableView.headerView(forSection: section)
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
