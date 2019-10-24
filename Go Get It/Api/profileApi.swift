//
//  profileApi.swift
//  Mona
//
//  Created by Tariq on 8/29/19.
//  Copyright © 2019 Tariq. All rights reserved.
//
import UIKit
import Alamofire
import SwiftyJSON
import MOLH

class profileApi: NSObject {
    
    class func profileApi (completion: @escaping(_ error: Error?, _ data: [productModel]?)-> Void){
        let header = [
            "Accept": "application/json",
            "Authorization": "Bearer \(helper.getUserToken() ?? "")"
        ]
        Alamofire.request(URLs.profile, method: .post, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON { response in
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
                print(data)
                var orderData = [productModel]()
                data.forEach({
                    if let dict = $0.dictionary, let product = productModel(dict: dict) {
                        orderData.append(product)
                    }
                })
                completion(nil, orderData)
            }
        }
    }
    
    class func updateProfileApi (name: String, email: String, phone: String, password: String,completion: @escaping(_ error: Error?, _ data: String?)-> Void){
        let parametars = [
            "name": name,
            "phone": phone,
            "email": email,
            "password": password
        ]
        let header = [
            "Accept": "application/json",
            "Authorization": "Bearer \(helper.getUserToken() ?? "")"
        ]
        Alamofire.request(URLs.updateProfile, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: header).responseJSON { response in
            switch response.result
            {
            case .failure(let error):
                print(error)
                completion(error, nil)
                
            case .success(let value):
                let json = JSON(value)
                print(json)
                
                guard let data = json["data"].string else {
                    completion(nil, nil)
                    return
                }
                
                completion(nil, data)
            }
        }
    }
    
    //privacies
    class func privacyApi (completion: @escaping(_ error: Error?, _ data: [productModel]?)-> Void){
        let parametars = [
            "lang" : "en".localized
        ]
        Alamofire.request(URLs.privacies, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: nil).responseJSON { response in
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
                print(data)
                var orderData = [productModel]()
                data.forEach({
                    if let dict = $0.dictionary, let product = productModel(dict: dict) {
                        orderData.append(product)
                    }
                })
                completion(nil, orderData)
            }
        }
    }
    
    class func updatePasswordApi (password: String, newPassword: String,completion: @escaping(_ error: Error?, _ data: String?)-> Void){
        let parametars = [
            "password": password,
            "new_password": newPassword
        ]
        let header = [
            "Accept": "application/json",
            "Authorization": "Bearer \(helper.getUserToken() ?? "")"
        ]
        Alamofire.request(URLs.change_password, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: header).responseJSON { response in
            switch response.result
            {
            case .failure(let error):
                print(error)
                completion(error, nil)
                
            case .success(let value):
                let json = JSON(value)
                print(json)
                
                guard let data = json["data"].string else {
                    completion(nil, nil)
                    return
                }
                
                completion(nil, data)
            }
        }
    }
}
