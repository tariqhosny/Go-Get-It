//
//  orderDetailsCell.swift
//  Go Get It
//
//  Created by Tariq on 10/20/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit

class orderDetailsCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var count: UILabel!
    
    func configureCell(product: productModel) {
        productName.text = product.product_name
        productPrice.text = "Price:".localized + " \(product.product_price)"
        count.text = "Count:".localized + " \(product.product_quantity)"
        let urlWithoutEncoding = ("\(URLs.file_root)\(product.image)")
        let encodedLink = urlWithoutEncoding.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let encodedURL = NSURL(string: encodedLink!)! as URL
        productImage.kf.indicatorType = .activity
        if let url = URL(string: "\(encodedURL)") {
            productImage.kf.setImage(with: url)
        }
    }
}
