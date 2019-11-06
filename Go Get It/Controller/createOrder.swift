//
//  createOrder.swift
//  Go Get It
//
//  Created by Tariq on 10/13/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class createOrder: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var phoneLb: UITextField!
    @IBOutlet weak var regionLb: UITextField!
    @IBOutlet weak var countryLb: UITextField!
    @IBOutlet weak var cityLb: UITextField!
    @IBOutlet weak var streetLb: UITextField!
    @IBOutlet weak var buildNumberLb: UITextField!
    @IBOutlet weak var floorNumberLb: UITextField!
    @IBOutlet weak var apartmenetNumberLb: UITextField!
    @IBOutlet weak var taxesLb: UILabel!
    @IBOutlet weak var deleveryLb: UILabel!
    @IBOutlet weak var totalPriceLb: UILabel!
    @IBOutlet weak var cashSwitch: UISwitch!
    @IBOutlet weak var paymentSwitch: UISwitch!
    
    var totalPrice = Float()
    var delivery = Int()
    var taxes = Float()
    var userLat = 0.0
    var userLng = 0.0
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.activityIndicator.isHidden = true
                
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        addTitleImage()
        
        taxesLb.text = "Taxes:".localized + " \(taxes)"
        deleveryLb.text = "Delivery Fees:".localized + " \(delivery)"
        totalPriceLb.text = "Total:".localized + " \(totalPrice)"
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func cashSwitshPressed(_ sender: UISwitch) {
        if cashSwitch.isOn{
            paymentSwitch.setOn(false, animated: true)
        }else{
            paymentSwitch.setOn(true, animated: true)
        }
    }
    
    @IBAction func paymentSwitchPressed(_ sender: UISwitch) {
        if paymentSwitch.isOn{
            cashSwitch.setOn(false, animated: true)
        }else{
            cashSwitch.setOn(true, animated: true)
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last! as CLLocation
        self.userLat = location.coordinate.latitude
        self.userLng = location.coordinate.longitude
        print("locations = \(location.coordinate.latitude) \(location.coordinate.longitude)")
        
    }
            
    @IBAction func getMyLocation(_ sender: Any) {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        getAddressFromLatLon(pdblLatitude: "\(self.userLat)", withLongitude: "\(self.userLng)")
    }

    @IBAction func orderNow(_ sender: UIButton) {
        guard let phone = phoneLb.text, let region = regionLb.text, let country = countryLb.text, let city = cityLb.text, let street = streetLb.text, let buildNumber = buildNumberLb.text, let floorNumber = floorNumberLb.text, let apartmenetNumber = apartmenetNumberLb.text else {return}
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        if (phone.isEmpty == true || region.isEmpty == true || country.isEmpty == true || city.isEmpty == true || street.isEmpty == true || buildNumber.isEmpty == true || floorNumber.isEmpty == true || apartmenetNumber.isEmpty == true){
            self.displayErrors(errorText: "Empty Fields".localized)
        }else {
            if self.cashSwitch.isOn{
                orderApi.createOrderApi(totalPrice: self.totalPrice, phone: phone, region: region, city: city, country: country, street: street, latidude: Float(self.userLat), langitude: Float(self.userLng), department: apartmenetNumber, floor_number: floorNumber, home_number: buildNumber, method: 2) { (error: Error?, success: Bool?) in
                    if success == true{
                        helper.restartApp()
                    }else{

                    }
                }
            }else if self.paymentSwitch.isOn{
                self.performSegue(withIdentifier: "payment", sender: nil)
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
            }else if !self.cashSwitch.isOn && !self.paymentSwitch.isOn{
                let alert = UIAlertController(title: "Faild".localized, message: "Please select the payment method".localized, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
            }
            
        }
    }
    
    func displayErrors (errorText: String){
        let alert = UIAlertController.init(title: "Error".localized, message: errorText, preferredStyle: .alert)
        let dismissAction = UIAlertAction.init(title: "Dismiss".localized, style: .default, handler: nil)
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
    }

    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        let lon: Double = Double("\(pdblLongitude)")!
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    self.regionLb.text = ("\(pm.subLocality ?? "")")
                    self.cityLb.text = "\(pm.administrativeArea ?? "")"
                    self.countryLb.text = "\(pm.country ?? "")"
                    self.streetLb.text = "\(pm.subThoroughfare ?? "") \(pm.thoroughfare ?? "")"
                }
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destenation = segue.destination as? paymentWebView{
            destenation.totalPrice = self.totalPrice
            destenation.region = self.regionLb.text ?? ""
            destenation.city = self.cityLb.text ?? ""
            destenation.country = self.countryLb.text ?? ""
            destenation.apartmenetNumber = self.apartmenetNumberLb.text ?? ""
            destenation.floorNumber = self.floorNumberLb.text ?? ""
            destenation.buildNumber = self.buildNumberLb.text ?? ""
            destenation.lang = Float(self.userLng)
            destenation.lat = Float(self.userLat)
            destenation.street = self.streetLb.text ?? ""
            destenation.phone = self.phoneLb.text ?? ""
        }
    }
}
extension createOrder {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
