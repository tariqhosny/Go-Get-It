//
//  orderDetails.swift
//  Go Get It
//
//  Created by Tariq on 10/14/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit

class orderDetails: UIViewController {
    
    @IBOutlet weak var addressLb: UILabel!
    @IBOutlet weak var paymentLb: UILabel!
    @IBOutlet weak var taxesLb: UILabel!
    @IBOutlet weak var deleveryLb: UILabel!
    @IBOutlet weak var priceLb: UILabel!
    @IBOutlet weak var productsTableView: UITableView!
    
    var products = [productModel]()
    var orderPrice = String()
    var orderID = Int()
    var deleveryFees = String()
    var taxs = Float()
    var orderState = String()
    var address = String()
    var paymentMethod = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addressLb.text = address
        self.priceLb.text = "Total Price:".localized + " \(orderPrice)"
        self.taxesLb.text = "Taxes:".localized + " \(taxs)"
        self.deleveryLb.text = "Delivery Fees:".localized + " \(deleveryFees)"
        self.paymentLb.text = paymentMethod
        
        productsTableView.delegate = self
        productsTableView.dataSource = self
        
        addTitleImage()
        orderDetailsHandelRefresh()
        // Do any additional setup after loading the view.
    }
    
    func orderDetailsHandelRefresh(){
        orderApi.orderDetailsApi(orderID: orderID) { (error: Error?, orders: [productModel]?) in
            if let products = orders{
                self.products = products
                self.productsTableView.reloadData()
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
}
extension orderDetails: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderDetailsCell", for: indexPath) as! orderDetailsCell
        let productData = products[indexPath.row]
        cell.configureCell(product: productData)
        return cell
    }
    
    
}
