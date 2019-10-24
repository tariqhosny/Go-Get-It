//
//  discoverCell.swift
//  Go Get It
//
//  Created by Tariq on 9/30/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit

class discoverCell: UICollectionViewCell {
    
    @IBOutlet weak var shoesImage: UIImageView!
    
    func configureCell(shoes: productModel){
        let urlWithoutEncoding = ("\(URLs.file_root)\(shoes.image)")
        let encodedLink = urlWithoutEncoding.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let encodedURL = NSURL(string: encodedLink!)! as URL
        shoesImage.kf.indicatorType = .activity
        if let url = URL(string: "\(encodedURL)") {
            shoesImage.kf.setImage(with: url)
        }
    }
    override func awakeFromNib() {
        self.layer.cornerRadius = 7.0
        self.layer.masksToBounds = true
    }
}
