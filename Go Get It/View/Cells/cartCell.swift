//
//  cartCell.swift
//  Go Get It
//
//  Created by Tariq on 10/7/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit

class cartCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productSize: UILabel!
    @IBOutlet weak var productDescreption: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var counter: UILabel!
    @IBOutlet weak var productTotalPrice: UILabel!
    
    var plus: (()->())?
    var min: (()->())?
    var delete: (()->())?
    
    func configureCell(product: productModel) {
        productSize.text = "Size:".localized + " \(product.size)"
        productName.text = product.product_name
        productDescreption.text = product.short_description
        productPrice.text = "Price:".localized + " \(product.unit_price)"
        productTotalPrice.text = "\(product.total_unit_price)"
        counter.text = product.quantity
        let urlWithoutEncoding = ("\(URLs.file_root)\(product.image)")
        let encodedLink = urlWithoutEncoding.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let encodedURL = NSURL(string: encodedLink!)! as URL
        productImage.kf.indicatorType = .activity
        if let url = URL(string: "\(encodedURL)") {
            productImage.kf.setImage(with: url)
        }
    }
    
    @IBAction func plusBtn(_ sender: UIButton) {
        plus?()
    }
    
    @IBAction func minBtn(_ sender: Any) {
        min?()
    }
    
    @IBAction func deleteBtn(_ sender: UIButton) {
        delete?()
    }

}
