//
//  CountryTableViewCell.swift
//  TravelTheWorld
//
//  Created by seodonghyun on 2017. 8. 10..
//  Copyright © 2017년 seodonghyun. All rights reserved.
//

import UIKit

class CountryTableViewCell: UITableViewCell {

    @IBOutlet var countryFlagImg: UIImageView!
    @IBOutlet var countryNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
