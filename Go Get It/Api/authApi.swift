//
//  authApi.swift
//  Go Get It
//
//  Created by Tariq on 9/29/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MOLH

class authApi: NSObject {

    class func registerApi(name: String, phone: String, email: String, password: String, completion: @escaping (_ error: Error?, _ success: Bool, _ validationMessage: String) -> Void){
        let parameters = [
            "name": name,
            "phone": phone,
            "email": email,
            "password": password
        ]
        Alamofire.request(URLs.register, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
            switch response.result{
            case .failure(let error):
                completion(error, false, "")
                print("error")
            case .success(let value):
                let json = JSON(value)
                let status = json["status"].bool
                if status == true{
                    if let user_token = json["data"]["user_token "].string{
                        completion(nil, true, "")
                        print("success")
                        helper.saveUserToken(token: user_token)
                    }
                }else{
                    if let validationMail = json["error"]["email"][0].string{
                        completion(nil, false, validationMail)
                    }
                    else if let validationName = json["error"]["name"][0].string{
                        completion(nil, false, validationName)
                    }
                    
                }
            }
        }
    }
    
    class func loginApi(email: String, password: String, completion: @escaping (_ error: Error?, _ success: Bool, _ validationMessage: String) -> Void){
        let parameters = [
            "email": email,
            "password": password
        ]
        Alamofire.request(URLs.login, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
        .responseJSON { response in
            switch response.result{
            case .failure(let error):
                completion(error,false,"")
            case .success(let value):
                let json = JSON(value)
                let status = json["status"].bool
                if status == true{
                    if let user_token = json["data"]["user_token "].string{
                        completion(nil,true,"")
                        helper.saveUserToken(token: user_token)
                    }
                }else{
                    completion(nil, false, "Email or Password incorrect".localized)
                }
            }
        }
    }
}
