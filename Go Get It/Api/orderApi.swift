//
//  orderApi.swift
//  Mona
//
//  Created by Tariq on 8/28/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MOLH

class orderApi: NSObject {
    
    class func createOrderApi (totalPrice: Float, phone: String, region: String, city: String, country: String, street: String, latidude: Float, langitude: Float, department: String, floor_number: String,home_number: String,method: Int, completion: @escaping(_ error: Error?, _ success: Bool?)-> Void){
        let parametars = [
            "order_total_price": totalPrice,
            "customer_address": region,
            "customer_phone": phone,
            "langtude": latidude,
            "lattude": langitude,
            "payment_method": method,
            "payment_status": 1,
            "customer_city": city,
            "customer_country": country,
            "customer_street": street,
            "customer_postal_code": 0,
            "customer_appartment_number": department,
            "customer_floor_number": floor_number,
            "customer_home_number": home_number
            ] as [String : Any]
        let header = [
            "Accept": "application/json",
            "Authorization": "Bearer \(helper.getUserToken() ?? "")"
        ]
        Alamofire.request(URLs.createOrder, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: header).responseJSON { response in
            switch response.result
            {
            case .failure(let error):
                print(error)
                completion(error, nil)
                
            case .success(let value):
                let json = JSON(value)
                print(json)
                completion(nil, true)
            }
        }
    }
    
    class func orderListApi (completion: @escaping(_ error: Error?, _ data: [productModel]?)-> Void){
        let parametars = [
            "lang": "en".localized
        ]
        let header = [
            "Accept": "application/json",
            "Authorization": "Bearer \(helper.getUserToken() ?? "")"
        ]
        Alamofire.request(URLs.orderList, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: header).responseJSON { response in
            switch response.result
            {
            case .failure(let error):
                print(error)
                completion(error, nil)
                
            case .success(let value):
                let json = JSON(value)
                print(json)
                
                guard let data = json["data"].array else {
                    completion(nil, nil)
                    return
                }
                var orderList = [productModel]()
                data.forEach({
                    if let dict = $0.dictionary, let product = productModel(dict: dict) {
                        orderList.append(product)
                    }
                })
                completion(nil, orderList)
            }
        }
    }
    
    class func orderDetailsApi (orderID:Int, completion: @escaping(_ error: Error?, _ data: [productModel]?)-> Void){
        let parametars = [
            "order_id": orderID
        ]
        let header = [
            "Accept": "application/json",
            "Authorization": "Bearer \(helper.getUserToken() ?? "")"
        ]
        Alamofire.request(URLs.orderDetails, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: header).responseJSON { response in
            switch response.result
            {
            case .failure(let error):
                print(error)
                completion(error, nil)
                
            case .success(let value):
                let json = JSON(value)
                print(json)
                
                guard let data = json["data"].array else {
                    completion(nil, nil)
                    return
                }
                var orderDetails = [productModel]()
                data.forEach({
                    if let dict = $0.dictionary, let product = productModel(dict: dict) {
                        orderDetails.append(product)
                    }
                })
                completion(nil, orderDetails)
            }
        }
    }
}
