//
//  locationTableViewCell.swift
//  KraudeSorce
//
//  Created by Ross Arkin on 12/7/16.
//  Copyright © 2016 Yash Dalal. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase 

class locationTableViewCell: UITableViewCell {

    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var locationImage: UIImageView!
    
    @IBOutlet weak var busyStatus: UILabel!
    var homePage: HomePageTableViewController! = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func update(){
        title.text = homePage.location
       
        if(homePage.currLocation == title.text){
            locationImage.image = UIImage(named: "1832-200")
        }
        else{
            locationImage.image = UIImage(named: "1832-200gray")
        }
        busyStatus.text = homePage.returnstring
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
