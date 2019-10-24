//
//  semilerProductCell.swift
//  Go Get It
//
//  Created by Tariq on 10/1/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit

class semilerProductCell: UICollectionViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var shortDescreption: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productGeneralPrice: UILabel!
    @IBOutlet weak var view: UIView!
    
    func configureCell(shoes: productModel){
        if shoes.sale_price == ""{
            productPrice.text = shoes.price_general
            view.isHidden = true
            productGeneralPrice.isHidden = true
        }else{
            productPrice.text = shoes.sale_price
            productGeneralPrice.text = shoes.price_general
        }
        productName.text = shoes.title
        shortDescreption.text = shoes.short_description
        let urlWithoutEncoding = ("\(URLs.file_root)\(shoes.image)")
        let encodedLink = urlWithoutEncoding.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let encodedURL = NSURL(string: encodedLink!)! as URL
        productImage.kf.indicatorType = .activity
        if let url = URL(string: "\(encodedURL)") {
            productImage.kf.setImage(with: url)
        }
    }
}
