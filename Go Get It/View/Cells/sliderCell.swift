//
//  sliderCell.swift
//  Go Get It
//
//  Created by Tariq on 9/30/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit

class sliderCell: UICollectionViewCell {
    
    @IBOutlet weak var sliderImage: UIImageView!
    
    func configureCell(shoes: productModel){
        let urlWithoutEncoding = ("\(URLs.file_root)\(shoes.image)")
        let encodedLink = urlWithoutEncoding.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let encodedURL = NSURL(string: encodedLink!)! as URL
        sliderImage.kf.indicatorType = .activity
        if let url = URL(string: "\(encodedURL)") {
            sliderImage.kf.setImage(with: url)
        }
    }
}
