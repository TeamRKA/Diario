//
//  RemindersTableViewCell.swift
//  MHacks9
//
//  Created by Kenan Dominic on 3/25/17.
//  Copyright © 2017 DeeptanhuRyujiKenanAvi. All rights reserved.
//

import UIKit
import MapKit

class RemindersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var shortDescriptionLabel: UILabel!
    @IBOutlet weak var fullDescriptionLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    
    var first: UIView?
    var second: UIView?
    var third: UIView?
    var fourth: UIView?
    var fifth: UIView?
    
    var mapExists: Bool = true
    var photoExists: Bool = true
    
    var isCollapsed: Bool = true

    override func awakeFromNib() {
        super.awakeFromNib()        
        first = stackView.arrangedSubviews[0]
        second = stackView.arrangedSubviews[1]
        third = stackView.arrangedSubviews[2]
        fourth = stackView.arrangedSubviews[4]
        fifth = stackView.arrangedSubviews[3]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func goToLocation(location: CLLocation) {
        DispatchQueue.main.async {
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        self.mapView.setRegion(region, animated: false)
        }
    }
    
    func addAnnotation(location: CLLocation) {
        DispatchQueue.main.async {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        self.mapView.addAnnotation(annotation)
        }
    }

}
