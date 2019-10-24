//
//  productDetailsImages.swift
//  Go Get It
//
//  Created by Tariq on 10/1/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit

class productDetailsImages: UICollectionViewCell {
    
    @IBOutlet weak var productImages: UIImageView!
    
    func configureCell(shoes: productModel){
        let urlWithoutEncoding = ("\(URLs.file_root)\(shoes.image)")
        let encodedLink = urlWithoutEncoding.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let encodedURL = NSURL(string: encodedLink!)! as URL
        productImages.kf.indicatorType = .activity
        if let url = URL(string: "\(encodedURL)") {
            productImages.kf.setImage(with: url)
        }
    }
}
