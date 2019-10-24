//
//  cart.swift
//  Go Get It
//
//  Created by Tariq on 10/1/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit

class cart: UIViewController {

    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var taxesLb: UILabel!
    @IBOutlet weak var deleveryLb: UILabel!
    @IBOutlet weak var totalPriceLb: UILabel!
    @IBOutlet weak var priceData: UIView!
    @IBOutlet weak var emptyCart: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var refreshControl = UIRefreshControl()
    var products = [productModel]()
    var cartID = Int()
    var price = Float()
    var delivery = Int()
    var taxes = Float()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.isHidden = true
        
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        cartTableView.refreshControl = refreshControl
        
        cartTableView.dataSource = self
        cartTableView.delegate = self

        cartHandleRefresh()
        addTitleImage()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        cartHandleRefresh()
        addTitleImage()
    }
    
    @objc func refresh(sender:AnyObject) {
        cartHandleRefresh()
        refreshControl.endRefreshing()
    }

    
    @objc func cartHandleRefresh() {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        cartApi.listCartApi { (error: Error?, product: [productModel]?, price, taxs, deleveryFees) in
            if let products = product {
                self.products = products
                print(self.products)
                self.price = price ?? 0
                self.delivery = Int(deleveryFees ?? "0") ?? 0
                self.taxes = taxs ?? 0
                self.totalPriceLb.text = "Total Price:".localized + " \(price ?? 0)"
                self.taxesLb.text = "Taxes:".localized + " $\(taxs ?? 0)"
                self.deleveryLb.text = "Delivery Fees:".localized + " $\(deleveryFees ?? "0")"
                self.cartTableView.reloadData()
            }
            if self.products.count == 0 {
                self.cartTableView.isHidden = true
                self.emptyCart.isHidden = false
                self.priceData.isHidden = true
            }else{
                self.cartTableView.isHidden = false
                self.emptyCart.isHidden = true
                self.priceData.isHidden = false
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
        if let destenation = segue.destination as? createOrder{
            destenation.totalPrice = self.price
            destenation.delivery = self.delivery
            destenation.taxes = self.taxes
        }
    }

}
extension cart : UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! cartCell
        let productData = products[indexPath.row]
        cell.plus = {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            self.cartID = self.products[indexPath.row].cart_id
            cartApi.plusCartApi(cartID: self.cartID, completion: { (error: Error?, success: Bool?) in
                if success == true{
                    print("increased")
                    self.cartHandleRefresh()
                }else{
                    print("failed")
                }
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            })
        }
        
        cell.min = {
            if self.products[indexPath.row].quantity == "1"{
                let alert = UIAlertController.init(title: "You Can't reduce any more!".localized, message: "", preferredStyle: .alert)
                let dismissAction = UIAlertAction.init(title: NSLocalizedString("ok", comment: ""), style: .default, handler: nil)
                alert.addAction(dismissAction)
                self.present(alert, animated: true, completion: nil)
            }else{
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
                self.cartID = self.products[indexPath.row].cart_id
                cartApi.minCartApi(cartID: self.cartID, completion: { (error: Error?, success: Bool?) in
                    if success == true{
                        print("decreased")
                        self.cartHandleRefresh()
                    }else{
                        print("failed")
                    }
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                })
                }
        }
        
        cell.delete = {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            self.cartID = self.products[indexPath.row].cart_id
            cartApi.deleteCartApi(cartID: self.cartID, completion: { (error: Error?, success: Bool?) in
                if success == true{
                    print("deleted")
                    self.cartHandleRefresh()
                }else{
                    print("failed")
                }
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            })
            if self.products.count == 1 {
                self.products.removeAll()
                self.totalPriceLb.text = " $0"
                self.taxesLb.text = " $0"
                self.deleveryLb.text = " $0"
                self.cartTableView.reloadData()
            }
        }
        cell.configureCell(product: productData)
        return cell
    }
    
}
