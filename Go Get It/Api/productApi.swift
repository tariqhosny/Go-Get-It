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
import MOLH

class productApi: NSObject {
    //products_category
    
    class func products_category (catId:String,completion: @escaping(_ error: Error?, _ photos: [productModel]?)-> Void){
        let parametars = [
            "category_id": catId,
            "lang": "en".localized
        ]
        Alamofire.request(URLs.products_category, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            
            switch response.result
            {
            case .failure(let error):
                print(error)
                completion(error, nil)
                
            case .success(let value):
                let json = JSON(value)
                //print(json)
                
                guard let data = json["data"].array else {
                    completion(nil, nil)
                    return
                }
                //print(data)
                var photos = [productModel]()
                data.forEach({
                    if let dict = $0.dictionary, let photo = productModel(dict: dict){
                        photos.append(photo)
                    }
                })
                completion(nil, photos)
            }
        }
    }
    
    class func brandsApi (url:String,completion: @escaping(_ error: Error?, _ photos: [productModel]?)-> Void){
        let parametars = [
            "lang": "en".localized
        ]
        Alamofire.request(url, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            
            switch response.result
            {
            case .failure(let error):
                print(error)
                completion(error, nil)
                
            case .success(let value):
                let json = JSON(value)
                //print(json)
                
                guard let data = json["data"].array else {
                    completion(nil, nil)
                    return
                }
                //print(data)
                var photos = [productModel]()
                data.forEach({
                    if let dict = $0.dictionary, let photo = productModel(dict: dict){
                        photos.append(photo)
                    }
                })
                completion(nil, photos)
            }
        }
    }
    
    class func catigoriesApi (completion: @escaping(_ error: Error?, _ photos: [productModel]?)-> Void){
        let parametars = [
            "lang": "en".localized
        ]
        Alamofire.request(URLs.categories, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            
            switch response.result
            {
            case .failure(let error):
                print(error)
                completion(error, nil)
                
            case .success(let value):
                let json = JSON(value)
                //print(json)
                
                guard let data = json["data"].array else {
                    completion(nil, nil)
                    return
                }
                //print(data)
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
    
    class func productApi (catID: String, completion: @escaping(_ error: Error?, _ photos: [productModel]?)-> Void){
        let parametars = [
            "category_id": catID,
            "brand_id": "",
            "lang": "en".localized
            ] as [String : Any]
        let header = [
            "Accept": "application/json",
            "Authorization": "Bearer \(helper.getUserToken() ?? "")"
        ]
        Alamofire.request(URLs.products, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: header).responseJSON { response in
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
                //print(data)
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
    
    class func newShoesApi(completion: @escaping(_ error: Error?,_ products: [productModel]?) -> Void){
        let parameters = [
            "lang": "en".localized
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

    class func shoesImagesApi(id: Int, completion: @escaping(_ error: Error?,_ products: [productModel]?) -> Void){
        let parameters = [
            "product_id": id
        ]
        
        Alamofire.request(URLs.productImages, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
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
    
    class func productSizesApi (id: Int, completion: @escaping(_ error: Error?, _ photos: [productModel]?)-> Void){
        let parametars = [
            "product_id": id
        ]
        Alamofire.request(URLs.sizes, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: nil).responseJSON { response in
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
                //print(data)
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
    
    class func allSizesApi (completion: @escaping(_ error: Error?, _ photos: [productModel]?)-> Void){
        let parametars = [
            "lang": "en".localized
        ]
        Alamofire.request(URLs.allSizes, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: nil).responseJSON { response in
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
                //print(data)
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
    
    class func allProductsApi (completion: @escaping(_ error: Error?, _ photos: [productModel]?)-> Void){
        let parametars = [
            "lang": "en".localized
            ]
        let header = [
            "Accept": "application/json",
            "Authorization": "Bearer \(helper.getUserToken() ?? "")"
        ]
        Alamofire.request(URLs.allProducts, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: header).responseJSON { response in
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
                //print(data)
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
    
    class func filterApi (brand_id: String, category_id: String, women: String, men: String, kid: String, min_price: String, max_price: String, size: String, completion: @escaping(_ error: Error?, _ photos: [productModel]?)-> Void){
        let parametars = [
            "lang": "en".localized,
            "brand_id": brand_id,
            "category_id": category_id,
            "women": women,
            "men": men,
            "kid": kid,
            "min_price": min_price,
            "max_price": max_price,
            "size": size
            ] as [String : Any]
        Alamofire.request(URLs.filter, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: nil).responseJSON { response in
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
                //print(data)
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
    
    class func similarProducts(id:Int,completion: @escaping(_ error: Error?, _ photos: [productModel]?)-> Void){
        let parametars = [
            "product_id": id,
            "lang": "en".localized
            ] as [String : Any]
        Alamofire.request(URLs.similar_products, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            
            switch response.result
            {
            case .failure(let error):
                print(error)
                completion(error, nil)
                
            case .success(let value):
                let json = JSON(value)
                //print(json)
                
                guard let data = json["data"].array else {
                    completion(nil, nil)
                    return
                }
                //print(data)
                var photos = [productModel]()
                data.forEach({
                    if let dict = $0.dictionary, let photo = productModel(dict: dict){
                        photos.append(photo)
                    }
                })
                completion(nil, photos)
            }
        }
    }
}
