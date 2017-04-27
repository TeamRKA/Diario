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
    /*
    @IBOutlet weak var tagView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var scheduleView: UIImageView!
 */
    
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
    
    var mapExists: Bool = true
    var photoExists: Bool = true
    
    var isCollapsed: Bool = true

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        /*
        tagView.layer.cornerRadius = tagView.frame.width / 2
        tagView.clipsToBounds = true
 */
        
        first = stackView.arrangedSubviews[0]
        second = stackView.arrangedSubviews[1]
        third = stackView.arrangedSubviews[2]
        fourth = stackView.arrangedSubviews[3]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
