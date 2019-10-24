//
//  newShoesCell.swift
//  Go Get It
//
//  Created by Tariq on 9/30/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit

class newShoesCell: UICollectionViewCell {
    
    @IBOutlet weak var shoesImage: UIImageView!
    @IBOutlet weak var shoesName: UILabel!
    @IBOutlet weak var shoesDes: UILabel!
    @IBOutlet weak var shoesPrice: UILabel!
    @IBOutlet weak var shoesGeneralPrice: UILabel!
    @IBOutlet weak var view: UIView!
    
    func configureCell(shoes: productModel){
        if shoes.sale_price == ""{
            shoesPrice.text = shoes.price_general
            view.isHidden = true
            shoesGeneralPrice.isHidden = true
        }else{
            shoesPrice.text = shoes.sale_price
            shoesGeneralPrice.text = shoes.price_general
        }
        shoesName.text = shoes.title
        shoesDes.text = shoes.short_description
        let urlWithoutEncoding = ("\(URLs.file_root)\(shoes.image)")
        let encodedLink = urlWithoutEncoding.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let encodedURL = NSURL(string: encodedLink!)! as URL
        shoesImage.kf.indicatorType = .activity
        if let url = URL(string: "\(encodedURL)") {
            shoesImage.kf.setImage(with: url)
        }
    }
}
