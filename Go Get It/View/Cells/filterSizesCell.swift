//
//  filterSizesCell.swift
//  Go Get It
//
//  Created by Tariq on 10/16/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit

class filterSizesCell: UITableViewCell {

    @IBOutlet weak var sizeName: UILabel!
    @IBOutlet weak var selectedCell: UIImageView!
    
    func configureCell(name: String){
        sizeName.text = name
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
