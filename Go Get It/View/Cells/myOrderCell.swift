//
//  myOrderCell.swift
//  Go Get It
//
//  Created by Tariq on 10/14/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit

class myOrderCell: UITableViewCell {

    @IBOutlet weak var dateLb: UILabel!
    @IBOutlet weak var priceLb: UILabel!
    @IBOutlet weak var numberLb: UILabel!
    @IBOutlet weak var stateLb: UILabel!
    
    func configureCell(orderList: productModel) {
        numberLb.text = "order:" + " \(orderList.order_id)"
        dateLb.text = "Date:" + " \(orderList.created_at)"
        priceLb.text = "Price: \(orderList.order_total_price)"
        
        if Int(orderList.order_stat) == 0{
            stateLb.text = "Order in Progress"
        }
        if Int(orderList.order_stat) == 1{
            stateLb.text = "Order Delivered"
        }
        if Int(orderList.order_stat) == 2{
            stateLb.text = "Order Canceled"
        }
    }

}
