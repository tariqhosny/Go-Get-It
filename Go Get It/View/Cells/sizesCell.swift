//
//  sizesCell.swift
//  Go Get It
//
//  Created by Tariq on 10/1/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit

class sizesCell: UICollectionViewCell {
    
    @IBOutlet weak var productSizes: UILabel!
    
    func configureCell(shoes: productModel){
        productSizes.text = shoes.size
    }
    
    override var isSelected: Bool {
        didSet{
            self.contentView.layer.backgroundColor = isSelected ? UIColor.gray.cgColor : UIColor.white.cgColor
            productSizes.textColor = isSelected ? UIColor.white : UIColor.gray
            layer.cornerRadius = isSelected ? 7.0 : 0.0
        }
    }
    
}
