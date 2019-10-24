//
//  productModel.swift
//  Go Get It
//
//  Created by Tariq on 9/29/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit
import SwiftyJSON

class productModel: NSObject {
    
    var image: String
    var title: String
    var short_description: String
    var id: Int
    var Description: String
    var price_general: String
    var sale_price: String
    var brand_name: String
    var image_guide: String
    var Wishlist_state: Int
    var name: String
    var phone: String
    var email: String
    var cart_id: Int
    var product_id: String
    var size: String
    var product_name: String
    var quantity: String
    var unit_price: String
    var total_unit_price: Float
    var total_tax: Float
    var total_delevery_fees: String
    var price: Float
    var order_id: Int
    var order_total_price: String
    var tax: Float
    var delevery_fees: String
    var order_stat: Int
    var customer_address: String
    var customer_city: String
    var customer_country: String
    var customer_street: String
    var langtude: String
    var lattude: String
    var payment_method: String
    var payment_status: String
    var customer_phone: String
    var created_at: String
    var product_quantity: String
    var product_price: String
    
    init?(dict:[String: JSON]){
        
        if let image = dict["image"]?.string{
            self.image = image
        }else{
            self.image = ""
        }
        
        if let title = dict["title"]?.string{
            self.title = title
        }else{
            self.title = ""
        }
        
        if let id = dict["id"]?.int{
            self.id = id
        }else{
            self.id = 0
        }
        
        if let short_description = dict["short_description"]?.string{
            self.short_description = short_description
        }else{
            self.short_description = ""
        }
        
        if let Description = dict["description"]?.string{
            self.Description = Description
        }else{
            self.Description = ""
        }
        
        if let price_general = dict["price_general"]?.string{
            self.price_general = price_general
        }else{
            self.price_general = ""
        }
        
        if let sale_price = dict["sale_price"]?.string{
            self.sale_price = sale_price
        }else{
            self.sale_price = ""
        }
        
        if let brand_name = dict["brand_name"]?.string{
            self.brand_name = brand_name
        }else{
            self.brand_name = ""
        }
        
        if let image_guide = dict["image_guide"]?.string{
            self.image_guide = image_guide
        }else{
            self.image_guide = ""
        }
        
        if let Wishlist_state = dict["Wishlist_state"]?.int{
            self.Wishlist_state = Wishlist_state
        }else{
            self.Wishlist_state = 0
        }
        
        if let name = dict["name"]?.string{
            self.name = name
        }else{
            self.name = ""
        }
        
        if let phone = dict["phone"]?.string{
            self.phone = phone
        }else{
            self.phone = ""
        }
        
        if let email = dict["email"]?.string{
            self.email = email
        }else{
            self.email = ""
        }
        
        if let cart_id = dict["cart_id"]?.int{
            self.cart_id = cart_id
        }else{
            self.cart_id = 0
        }
        
        if let product_id = dict["product_id"]?.string{
            self.product_id = product_id
        }else{
            self.product_id = ""
        }
        
        if let size = dict["size"]?.string{
            self.size = size
        }else{
            self.size = ""
        }
        
        if let product_name = dict["product_name"]?.string{
            self.product_name = product_name
        }else{
            self.product_name = ""
        }
        
        if let quantity = dict["quantity"]?.string{
            self.quantity = quantity
        }else{
            self.quantity = ""
        }
        
        if let unit_price = dict["unit_price"]?.string{
            self.unit_price = unit_price
        }else{
            self.unit_price = ""
        }
        
        if let total_unit_price = dict["total_unit_price"]?.float{
            self.total_unit_price = total_unit_price
        }else{
            self.total_unit_price = 0
        }
        
        if let total_tax = dict["total_tax"]?.float{
            self.total_tax = total_tax
        }else{
            self.total_tax = 0
        }
        
        if let total_delevery_fees = dict["total_delevery_fees"]?.string{
            self.total_delevery_fees = total_delevery_fees
        }else{
            self.total_delevery_fees = ""
        }
        
        if let price = dict["price"]?.float{
            self.price = price
        }else{
            self.price = 0
        }
        
        if let order_id = dict["order_id"]?.int{
            self.order_id = order_id
        }else{
            self.order_id = 0
        }
        
        if let order_total_price = dict["order_total_price"]?.string{
            self.order_total_price = order_total_price
        }else{
            self.order_total_price = ""
        }
        
        if let tax = dict["tax"]?.float{
            self.tax = tax
        }else{
            self.tax = 0
        }
        
        if let delevery_fees = dict["delevery_fees"]?.string{
            self.delevery_fees = delevery_fees
        }else{
            self.delevery_fees = ""
        }
        
        if let order_stat = dict["order_stat"]?.int{
            self.order_stat = order_stat
        }else{
            self.order_stat = 0
        }
        
        if let customer_address = dict["customer_address"]?.string{
            self.customer_address = customer_address
        }else{
            self.customer_address = ""
        }
        
        if let customer_city = dict["customer_city"]?.string{
            self.customer_city = customer_city
        }else{
            self.customer_city = ""
        }
        
        if let customer_country = dict["customer_country"]?.string{
            self.customer_country = customer_country
        }else{
            self.customer_country = ""
        }
        
        if let customer_street = dict["customer_street"]?.string{
            self.customer_street = customer_street
        }else{
            self.customer_street = ""
        }
        
        if let langtude = dict["langtude"]?.string{
            self.langtude = langtude
        }else{
            self.langtude = ""
        }
        
        if let lattude = dict["lattude"]?.string{
            self.lattude = lattude
        }else{
            self.lattude = ""
        }
        
        if let payment_method = dict["payment_method"]?.string{
            self.payment_method = payment_method
        }else{
            self.payment_method = ""
        }
        
        if let payment_status = dict["payment_status"]?.string{
            self.payment_status = payment_status
        }else{
            self.payment_status = ""
        }
        
        if let customer_phone = dict["customer_phone"]?.string{
            self.customer_phone = customer_phone
        }else{
            self.customer_phone = ""
        }
        
        if let created_at = dict["created_at"]?.string{
            self.created_at = created_at
        }else{
            self.created_at = ""
        }
        
        if let product_quantity = dict["product_quantity"]?.string{
            self.product_quantity = product_quantity
        }else{
            self.product_quantity = ""
        }
        
        if let product_price = dict["product_price"]?.string{
            self.product_price = product_price
        }else{
            self.product_price = ""
        }
    }

}
