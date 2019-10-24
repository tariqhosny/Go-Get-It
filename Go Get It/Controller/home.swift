//
//  home.swift
//  Go Get It
//
//  Created by Tariq on 9/30/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit
import MOLH

class home: UIViewController {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var latestCollectionView: UICollectionView!
    @IBOutlet weak var heightConstrain: NSLayoutConstraint!
    @IBOutlet weak var discoverCollectionView: UICollectionView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var viewScrolled: UIView!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var image = [productModel]()
    var newShoes = [productModel]()
    var discover = [productModel]()
    var cart = [productModel]()
    var timer : Timer?
    var currentIndex = 0
    var id = Int()
    var shortDescreption = String()
    var longDescreption = String()
    var productName = String()
    var productprice = String()
    var productGeneralPrice = String()
    var productBrand = String()
    var discoverId = Int()
    var selectedFunc = "all"
    var collectionHeight = CGFloat()
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.isHidden = true
        
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        scroll.refreshControl = refreshControl
        
        if revealViewController() != nil {
            if MOLHLanguage.currentAppleLanguage() == "en"{
                menuButton.target = revealViewController()
                menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            }else{
                menuButton.target = revealViewController()
                menuButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            }
            view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }

        self.navigationController?.navigationBar.backItem?.title = ""
        
        sliderCollectionView.delegate = self
        sliderCollectionView.dataSource = self
        latestCollectionView.delegate = self
        latestCollectionView.dataSource = self
        discoverCollectionView.delegate = self
        discoverCollectionView.dataSource = self
        
        cartCounter()
        startTimer()
        addTitleImage()
        sliderHandelRefresh()
        newShoesHandelRefresh()
        discoverHandelRefresh()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        selectedFunc = "all"
        cartCounter()
        sliderHandelRefresh()
        newShoesHandelRefresh()
        discoverHandelRefresh()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    @objc func refresh(sender:AnyObject) {
        cartCounter()
        sliderHandelRefresh()
        newShoesHandelRefresh()
        discoverHandelRefresh()
        refreshControl.endRefreshing()
    }
    
    func sliderHandelRefresh(){
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        homeApi.sliderApi { (error: Error?, image: [productModel]?) in
            if let photo = image{
                self.image = photo
                self.pageControl.numberOfPages = self.image.count
                self.pageControl.currentPage = 0
                self.sliderCollectionView.reloadData()
            }
            self.addBadge()
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        }
    }
    
    func newShoesHandelRefresh(){
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        productApi.newShoesApi { (error: Error?, product: [productModel]?) in
            if let shoes = product{
                self.newShoes = shoes
                self.latestCollectionView.reloadData()
                self.collectionHeight = self.latestCollectionView.collectionViewLayout.collectionViewContentSize.height
                self.heightConstrain.constant = self.collectionHeight
                self.viewHeight.constant = self.collectionHeight + 550
                self.view.layoutIfNeeded()
            }
            self.addBadge()
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        }
        
    }
    
    @objc fileprivate func discoverHandelRefresh() {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        productApi.catigoriesApi{ (error: Error?, product: [productModel]?) in
            if let products = product {
                self.discover = products
                self.discoverCollectionView.reloadData()
            }
            self.addBadge()
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        }
    }
    
    func startTimer(){
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
    }
    
    @objc func changeImage() {
        
        if currentIndex < image.count {
            let index = IndexPath.init(item: currentIndex, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageControl.currentPage = currentIndex
            currentIndex += 1
        } else {
            currentIndex = 0
            let index = IndexPath.init(item: currentIndex, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            pageControl.currentPage = currentIndex
            currentIndex = 1
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
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        cart.removeAll()
        cartApi.cartCountApi { (error: Error?, cartData: [productModel]?) in
            if let cartCounter = cartData{
                self.cart = cartCounter
            }
            self.addBadge()
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
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
        if let destenation = segue.destination as? allProducts{
            destenation.discoverId = self.discoverId
            destenation.selectedFunc = self.selectedFunc
        }
    }

}
extension home: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == sliderCollectionView{
            return image.count
        }else if collectionView == latestCollectionView{
            return newShoes.count
        }else{
            return discover.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == sliderCollectionView{
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sliderCell", for: indexPath) as? sliderCell{
                let sliderImg = image[indexPath.item]
                cell.configureCell(shoes: sliderImg)
                return cell
            }
            else{
                return sliderCell()
            }
        }else if collectionView == latestCollectionView{
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newShoesCell", for: indexPath) as? newShoesCell{
                let sliderImg = newShoes[indexPath.item]
                cell.configureCell(shoes: sliderImg)
                return cell
            }
            else{
                return newShoesCell()
            }
        }
        else{
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "discoverCell", for: indexPath) as? discoverCell{
                let sliderImg = discover[indexPath.item]
                cell.configureCell(shoes: sliderImg)
                return cell
            }
            else{
                return discoverCell()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == latestCollectionView{
            self.id = newShoes[indexPath.item].id
            self.productName = newShoes[indexPath.item].title
            self.productprice = newShoes[indexPath.item].sale_price
            self.productGeneralPrice = newShoes[indexPath.item].price_general
            self.shortDescreption = newShoes[indexPath.item].short_description
            self.longDescreption = newShoes[indexPath.item].Description
            self.productBrand = newShoes[indexPath.item].brand_name
            performSegue(withIdentifier: "details", sender: nil)
        }
        if collectionView == discoverCollectionView{
            self.discoverId = discover[indexPath.item].id
            self.selectedFunc = "discover"
            performSegue(withIdentifier: "product", sender: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == latestCollectionView{
            let screenWidth = collectionView.frame.width
            var width = (screenWidth-10)/2
            width = width < 130 ? 160 : width
            return CGSize.init(width: width, height: 152)
        }else if collectionView == discoverCollectionView{
            return CGSize.init(width: 150, height: 150)
        }
        else {
            return CGSize.init(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        }

    }
    
    
}
