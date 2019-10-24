//
//  allProducts.swift
//  Go Get It
//
//  Created by Tariq on 10/1/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit

class allProducts: UIViewController {

    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var noProductImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var allProducts = [productModel]()
    var cart = [productModel]()
    var id = Int()
    var shortDescreption = String()
    var longDescreption = String()
    var productName = String()
    var productprice = String()
    var productGeneralPrice = String()
    var productBrand = String()
    var discoverId = Int()
    var selectedFunc = String()
    var brandId = String()
    var catId = String()
    var size = String()
    var men = String()
    var women = String()
    var kid = String()
    var minPrice = String()
    var maxPrice = String()
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.isHidden = true
        
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        productsCollectionView.refreshControl = refreshControl
        
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
        cartCounter()
        allProductsHandleRefresh()
        addTitleImage()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
        
    override func viewDidDisappear(_ animated: Bool) {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    @objc func refresh(sender:AnyObject) {
        allProductsHandleRefresh()
        refreshControl.endRefreshing()
    }
    
    func allProductsHandleRefresh(){
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        if selectedFunc == "all"{
            productApi.allProductsApi{ (error: Error?, products: [productModel]?) in
                if let product = products {
                    self.allProducts = product
                    self.productsCollectionView.reloadData()
                }
                self.addBadge()
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
        }else if selectedFunc == "discover"{
            productApi.products_category(catId: String(discoverId)) { (error: Error?, product: [productModel]?) in
                if let products = product {
                    self.allProducts = products
                    self.productsCollectionView.reloadData()
                }
                self.addBadge()
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
        }else if selectedFunc == "filter"{
            productApi.filterApi(brand_id: brandId, category_id: catId, women: women, men: men, kid: kid, min_price: minPrice, max_price: maxPrice, size: size) { (error: Error?, product: [productModel]?) in
                if let products = product {
                    self.allProducts = products
                    self.productsCollectionView.reloadData()
                }
                self.addBadge()
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
        }
        
    }
    
    func addTitleImage(){
        let navController = navigationController!
        
        let image = UIImage(named: "gray")
        let imageView = UIImageView(image: image)
        
        let bannerWidth = navController.navigationBar.frame.size.width
        let bannerHeight = navController.navigationBar.frame.size.height
        
        let bannerX = bannerWidth / 2 - (image?.size.width)! / 2
        let bannerY = bannerHeight / 2 - (image?.size.height)! / 2
        
        imageView.frame = CGRect(x: bannerX, y: bannerY, width: image!.size.width, height: bannerHeight)
        imageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = imageView
    }
    
    @objc fileprivate func cartCounter(){
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
        cartApi.cartCountApi { (error: Error?, cartData: [productModel]?) in
            if let cartCounter = cartData{
                self.cart = cartCounter
            }
            self.addBadge()
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
    
    func addBadge() {
        let bagButton = BadgeButton()
        bagButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        bagButton.tintColor = UIColor.white
        bagButton.setImage(UIImage(named: "cart"), for: .normal)
        bagButton.badgeEdgeInsets = UIEdgeInsets(top: 17, left: 0, bottom: 0, right: 10)
        bagButton.badge = "\(cart.count)"
        bagButton.addTarget(self, action: #selector(self.cartTaped), for: UIControl.Event.touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: bagButton)
    }
    
    @objc func cartTaped(){
        self.performSegue(withIdentifier: "cart", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destenation = segue.destination as? productDetails{
            destenation.id = self.id
            destenation.productName = self.productName
            destenation.productprice = self.productprice
            destenation.productGeneralPrice = self.productGeneralPrice
            destenation.shortDescreption = self.shortDescreption
            destenation.longDescreption = self.longDescreption
            destenation.productBrand = self.productBrand
        }
    }

}
extension allProducts: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.allProducts.count == 0{
            self.noProductImage.isHidden = false
        }else{
            self.noProductImage.isHidden = true
        }
        return allProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "allProductsCell", for: indexPath) as? allProductsCell{
            let products = allProducts[indexPath.item]
            cell.configureCell(shoes: products)
            return cell
        }else{
            return allProductsCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.id = allProducts[indexPath.item].id
        self.productName = allProducts[indexPath.item].title
        self.productprice = allProducts[indexPath.item].sale_price
        self.productGeneralPrice = allProducts[indexPath.item].price_general
        self.shortDescreption = allProducts[indexPath.item].short_description
        self.longDescreption = allProducts[indexPath.item].Description
        self.productBrand = allProducts[indexPath.item].brand_name
        performSegue(withIdentifier: "details", sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = collectionView.frame.width
        var width = (screenWidth-10)/2
        width = width < 130 ? 160 : width
        return CGSize.init(width: width, height: 220)
    }
    
}
