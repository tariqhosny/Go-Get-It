//
//  homeApi.swift
//  Go Get It
//
//  Created by Tariq on 9/30/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MOLH

class homeApi: NSObject {
    
    class func sliderApi(completion: @escaping(_ error: Error?, _ image: [productModel]?) -> Void){
        let parameters = [
            "lang": "en".localized
        ]
        Alamofire.request(URLs.slider, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
            switch response.result{
            case .failure(let error):
                completion(error, nil)
            case .success(let value):
                let json = JSON(value)
                print(json)
                guard let data = json["data"].array else {
                    completion(nil, nil)
                    return
                }
                
                var photos = [productModel]()
                data.forEach({
                    if let dict = $0.dictionary, let photo = productModel(dict: dict) {
                        photos.append(photo)
                    }
                })
                completion(nil, photos)
            }
        }
    }

}
