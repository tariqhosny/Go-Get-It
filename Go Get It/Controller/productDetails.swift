//
//  productDetails.swift
//  Go Get It
//
//  Created by Tariq on 10/1/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit

class productDetails: UIViewController {

    @IBOutlet weak var ImagesCollectionVew: UICollectionView!
    @IBOutlet weak var sizesCollectionVew: UICollectionView!
    @IBOutlet weak var semilerCollectionVew: UICollectionView!
    @IBOutlet weak var productPriceLb: UILabel!
    @IBOutlet weak var productGeneralPriceLb: UILabel!
    @IBOutlet weak var productNameLb: UILabel!
    @IBOutlet weak var productBrandLb: UILabel!
    @IBOutlet weak var shortDescreptionLb: UILabel!
    @IBOutlet weak var longDescreptionLb: UILabel!
    @IBOutlet weak var viewprice: UIView!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var images = [productModel]()
    var sizes = [productModel]()
    var semiler = [productModel]()
    var id = Int()
    var sizeId = String()
    var selected = Int()
    var shortDescreption = String()
    var longDescreption = String()
    var productName = String()
    var productprice = String()
    var productGeneralPrice = String()
    var productBrand = String()
    var index = Int()
    var refreshControl = UIRefreshControl()
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.isHidden = true
        
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        scroll.refreshControl = refreshControl

        selected = 0
        
        ImagesCollectionVew.delegate = self
        ImagesCollectionVew.dataSource = self
        sizesCollectionVew.delegate = self
        sizesCollectionVew.dataSource = self
        semilerCollectionVew.delegate = self
        semilerCollectionVew.dataSource = self
        
        if productprice == ""{
            productPriceLb.text = productGeneralPrice
            viewprice.isHidden = true
            productGeneralPriceLb.isHidden = true
        }else{
            productPriceLb.text = productprice
            productGeneralPriceLb.text = productGeneralPrice
        }
        productNameLb.text = productName
        productBrandLb.text = productBrand
        shortDescreptionLb.text = shortDescreption
        longDescreptionLb.text = longDescreption
        
        sizesHandleRefresh()
        similerHandelRefresh()
        shoesImagesHandelRefresh()
        addTitleImage()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        sizesHandleRefresh()
        similerHandelRefresh()
        shoesImagesHandelRefresh()
        addTitleImage()
    }
    
    @objc func refresh(sender:AnyObject) {
        sizesHandleRefresh()
        similerHandelRefresh()
        shoesImagesHandelRefresh()
        refreshControl.endRefreshing()
    }
    
    @objc fileprivate func sizesHandleRefresh() {
        productApi.productSizesApi(id: id) { (error: Error?, product: [productModel]?) in
            if let products = product {
                self.sizes = products
                self.sizesCollectionVew.reloadData()
            }
        }
    }
    
    func shoesImagesHandelRefresh(){
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        productApi.shoesImagesApi(id: id) {(error: Error?, product: [productModel]?) in
            if let shoes = product{
                self.images = shoes
                self.pageControl.numberOfPages = self.images.count
                if self.images.count == 0 {
                    self.images.removeAll()
                    self.ImagesCollectionVew.reloadData()
                }
                self.ImagesCollectionVew.reloadData()
            }
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
    
    func similerHandelRefresh(){
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        productApi.similarProducts(id: id) { (error: Error?, product: [productModel]?) in
            if let shoes = product{
                self.semiler = shoes
                self.semilerCollectionVew.reloadData()
            }
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destenation = segue.destination as? imagesViewer{
            destenation.productID = self.id
            destenation.image = self.images
            destenation.index = self.index
        }
    }
    
    @IBAction func addToCardBtn(_ sender: UIButton) {
        
            if self.selected == 0{
                let alert = UIAlertController(title: "Please Select Size".localized, message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok".localized, style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
                cartApi.addCartApi(id: id, size: sizeId) { (error: Error?, success: Bool?) in
                    
                    self.performSegue(withIdentifier: "cart", sender: nil)
                
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }
            }
    }

}
extension productDetails: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == ImagesCollectionVew{
            return images.count
        }else if collectionView == sizesCollectionVew{
            return sizes.count
        }else{
            return semiler.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == ImagesCollectionVew{
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productDetailsImages", for: indexPath) as? productDetailsImages{
                let productImg = images[indexPath.item]
                cell.configureCell(shoes: productImg)
                return cell
            }else{
                return productDetailsImages()
            }
        }else if collectionView == sizesCollectionVew{
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sizesCell", for: indexPath) as? sizesCell{
                let productImg = sizes[indexPath.item]
                cell.configureCell(shoes: productImg)
                return cell
            }else{
                return sizesCell()
            }
        }else{
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "semilerProductCell", for: indexPath) as? semilerProductCell{
                let productImg = semiler[indexPath.item]
                cell.configureCell(shoes: productImg)
                return cell
            }else{
                return semilerProductCell()
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == semilerCollectionVew{
            images.removeAll()
            ImagesCollectionVew.reloadData()
            sizes.removeAll()
            sizesCollectionVew.reloadData()
            self.id = semiler[indexPath.item].id
            self.productName = semiler[indexPath.item].title
            self.productprice = semiler[indexPath.item].sale_price
            self.productGeneralPrice = semiler[indexPath.item].price_general
            self.shortDescreption = semiler[indexPath.item].short_description
            self.longDescreption = semiler[indexPath.item].Description
            self.productBrand = semiler[indexPath.item].brand_name
            self.scroll.setContentOffset(.zero, animated: false)
            self.viewDidLoad()
        }
        
        if collectionView == ImagesCollectionVew{
            self.index = indexPath.item
            performSegue(withIdentifier: "images", sender: nil)
        }
        
        if collectionView == sizesCollectionVew{
            selected = 1
            self.sizeId = sizes[indexPath.row].size
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == sizesCollectionVew{
            return CGSize.init(width: 100, height: 50)
        }else if collectionView == semilerCollectionVew{
            return CGSize.init(width: 160, height: 160)
        }else{
            return CGSize.init(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        }

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag == 0{
            currentIndex = Int(scrollView.contentOffset.x / ImagesCollectionVew.frame.size.width)
            pageControl.currentPage = currentIndex
        }
    }
    
}
