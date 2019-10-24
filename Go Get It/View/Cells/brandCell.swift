//
//  brandCell.swift
//  Go Get It
//
//  Created by Tariq on 10/16/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit

class brandCell: UITableViewCell {

    @IBOutlet weak var brandName: UILabel!
    @IBOutlet weak var selectedCell: UIImageView!
    
    func configureCell(name: String){
        brandName.text = name
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectedCell.isHidden = selected ? false : true
    }

}
