//
//  productApi.swift
//  Go Get It
//
//  Created by Tariq on 9/30/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class productApi: NSObject {
    
    class func newShoesApi(completion: @escaping(_ error: Error?,_ products: [productModel]?) -> Void){
        let parameters = [
            "lang": "en"
        ]
        let header = [
            "Accept": "application/json",
            "Authorization": "Bearer \(helper.getUserToken() ?? "")"
        ]
        
        Alamofire.request(URLs.latestProduct, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: header).responseJSON { response in
            switch response.result{
            case .failure(let error):
                completion(error, nil)
            case .success(let value):
                let json = JSON(value)
                guard let data = json["data"].array else {
                   completion(nil, nil)
                   return
                }
                var product = [productModel]()
                data.forEach({
                    if let dict = $0.dictionary, let shoes = productModel(dict: dict) {
                        product.append(shoes)
                    }
                })
                completion(nil, product)
            }
        }
    }

}
