//
//  filterGenderCell.swift
//  Go Get It
//
//  Created by Tariq on 10/3/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit

class filterGenderCell: UITableViewCell {

    @IBOutlet weak var genderLb: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    
    func configureCell(gender: String){
        genderLb.text = gender
    }

}
