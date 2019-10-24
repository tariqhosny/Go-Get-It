//
//  filterCategory.swift
//  Go Get It
//
//  Created by Tariq on 10/1/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit

class filterCategory: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var gender = ["MEN".localized, "WOMEN".localized, "KIDS".localized]
    var selectedGender = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

        addTitleImage()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
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
        if let destenation = segue.destination as? filter{
            destenation.selectedGender = self.selectedGender
        }
    }

}
extension filterCategory: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gender.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "filterGenderCell", for: indexPath) as? filterGenderCell{
            cell.configureCell(gender: gender[indexPath.row])
            return cell
        }else{
            return filterGenderCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedGender = gender[indexPath.row]
        performSegue(withIdentifier: "filter", sender: nil)
    }
    
}
