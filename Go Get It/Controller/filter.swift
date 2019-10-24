//
//  filter.swift
//  Go Get It
//
//  Created by Tariq on 10/1/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit

class filter: UIViewController {

    @IBOutlet weak var genderLb: UILabel!
    @IBOutlet weak var minPrice: UITextField!
    @IBOutlet weak var maxPrice: UITextField!
    @IBOutlet weak var categoryTableView: UITableView!
    @IBOutlet weak var brandTableView: UITableView!
    @IBOutlet weak var sizeTableView: UITableView!
    
    var selectedGender = String()
    var categories = [productModel]()
    var brands = [productModel]()
    var sizes = [productModel]()
    var brandId = String()
    var catId = String()
    var size = String()
    var men = String()
    var women = String()
    var kid = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        ["MEN", "WOMEN", "KIDS"]
        self.genderLb.text = selectedGender
        
        if genderLb.text == "MEN".localized{
            men = "1"
            women = ""
            kid = ""
        }
        if genderLb.text == "WOMEN".localized{
            men = ""
            women = "1"
            kid = ""
        }
        if genderLb.text == "KIDS".localized{
            men = ""
            women = ""
            kid = "1"
        }
        
        categoryTableView.dataSource = self
        categoryTableView.delegate = self
        brandTableView.dataSource = self
        brandTableView.delegate = self
        sizeTableView.dataSource = self
        sizeTableView.delegate = self
        
        addTitleImage()
        categoriesHandleRefresh()
        brandsHandleRefresh()
        sizesHandleRefresh()
        // Do any additional setup after loading the view.
    }
    
    @objc fileprivate func categoriesHandleRefresh() {
        productApi.brandsApi(url: URLs.categories) { (error: Error?, product: [productModel]?) in
            if let products = product {
                self.categories.append(contentsOf: products)
                self.categoryTableView.reloadData()
            }
        }
    }
    
    @objc fileprivate func brandsHandleRefresh() {
        productApi.brandsApi(url: URLs.brands) { (error: Error?, product: [productModel]?) in
            if let products = product {
                self.brands.append(contentsOf: products)
                self.brandTableView.reloadData()
            }
        }
    }
    
    @objc fileprivate func sizesHandleRefresh() {
        productApi.allSizesApi{ (error: Error?, product: [productModel]?) in
            if let products = product {
                self.sizes.append(contentsOf: products)
                self.sizeTableView.reloadData()
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
        
        imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth, height: bannerHeight)
        imageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = imageView
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destenation = segue.destination as? allProducts{
            destenation.brandId = self.brandId
            destenation.catId = self.catId
            destenation.size = self.size
            destenation.men = self.men
            destenation.women = self.women
            destenation.kid = self.kid
            destenation.minPrice = self.minPrice.text ?? ""
            destenation.maxPrice = self.maxPrice.text ?? ""
            destenation.selectedFunc = "filter"
        }
    }
    
    @IBAction func clearBtn(_ sender: UIBarButtonItem) {
        
        self.categoryTableView.reloadData()
        self.brandTableView.reloadData()
        self.sizeTableView.reloadData()
        self.minPrice.text = ""
        self.maxPrice.text = ""
        
    }
    
    @IBAction func filterPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "products", sender: nil)
    }
    
}
extension filter: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == categoryTableView{
            return categories.count
        }else if tableView == brandTableView{
            return brands.count
        }else{
            return sizes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == categoryTableView{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "catCell", for: indexPath) as? catCell{
                cell.configureCell(name: categories[indexPath.row].title)
                return cell
            }else{
                return catCell()
            }
        }else if tableView == brandTableView{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "brandCell", for: indexPath) as? brandCell{
                cell.configureCell(name: brands[indexPath.row].title)
                return cell
            }else{
                return brandCell()
            }
        }else{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "filterSizesCell", for: indexPath) as? filterSizesCell{
                cell.configureCell(name: sizes[indexPath.row].title)
                return cell
            }else{
                return filterSizesCell()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == categoryTableView{
            self.catId = "\(categories[indexPath.row].id)"
        }
        if tableView == brandTableView{
            self.brandId = "\(brands[indexPath.row].id)"
        }
        if tableView == sizeTableView{
            self.size = "\(sizes[indexPath.row].title)"
        }
    }
    
}
