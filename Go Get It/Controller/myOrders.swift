//
//  myOrders.swift
//  Go Get It
//
//  Created by Tariq on 10/1/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit
import MOLH

class myOrders: UIViewController {

    @IBOutlet weak var ordersTableView: UITableView!
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var orders = [productModel]()
    var orderPrice = String()
    var orderID = Int()
    var deleveryFees = String()
    var taxs = Float()
    var orderState = String()
    var address = String()
    var paymentMethod = String()
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.isHidden = true
        
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        ordersTableView.refreshControl = refreshControl
        
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

        ordersTableView.dataSource = self
        ordersTableView.delegate = self
        
        addTitleImage()
        OrderListHandleRefresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ordersTableView.reloadData()
        OrderListHandleRefresh()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
        
    override func viewDidDisappear(_ animated: Bool) {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    @objc func refresh(sender:AnyObject) {
        OrderListHandleRefresh()
        refreshControl.endRefreshing()
    }
    
    @objc fileprivate func OrderListHandleRefresh() {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        orders.removeAll()
        ordersTableView.reloadData()
        orderApi.orderListApi { (error: Error?, orderList: [productModel]?) in
            if let products = orderList {
                self.orders = products
                self.count.text = "\(self.orders.count)"
                self.ordersTableView.reloadData()
            }
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destenation = segue.destination as? orderDetails{
            destenation.orderPrice = self.orderPrice
            destenation.orderID = self.orderID
            destenation.deleveryFees = self.deleveryFees
            destenation.taxs = self.taxs
            destenation.orderState = self.orderState
            destenation.address = self.address
            destenation.paymentMethod = self.paymentMethod
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
extension myOrders: UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myOrderCell", for: indexPath) as! myOrderCell
        let productData = orders[indexPath.row]
        cell.configureCell(orderList: productData)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.orderPrice = orders[indexPath.row].order_total_price
        self.orderID = orders[indexPath.row].order_id
        self.deleveryFees = orders[indexPath.row].delevery_fees
        self.taxs = orders[indexPath.row].tax
        self.address = "\(orders[indexPath.row].customer_country), \(orders[indexPath.row].customer_city), \(orders[indexPath.row].customer_address), \(orders[indexPath.row].customer_street)"

        if Int(orders[indexPath.row].order_stat) == 0{
            self.orderState = "Order in Progress".localized
        }
        if Int(orders[indexPath.row].order_stat) == 1{
            self.orderState = "Order Delivered".localized
        }
        if Int(orders[indexPath.row].order_stat) == 2{
            self.orderState = "Order Canceled".localized
        }
        
        if Int(orders[indexPath.row].payment_status) == 1{
            self.paymentMethod = "Payment Online".localized
        }
        if Int(orders[indexPath.row].payment_method) == 2{
            self.paymentMethod = "Cash on Delivered".localized
        }
        
        performSegue(withIdentifier: "details", sender: nil)
    }
    
}
