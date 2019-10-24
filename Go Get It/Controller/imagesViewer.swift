//
//  imagesViewer.swift
//  Style Cosmetics
//
//  Created by Tariq on 10/9/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class imagesViewer: UIViewController {
    
    @IBOutlet weak var images: UIImageView!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    var image = [productModel]()
    var productID = Int()
    var index = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(index)
        
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(onDrage(_:))))
        
        imagesHandleRefresh()

        
        
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        imagesHandleRefresh()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {    super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
     @objc func onDrage(_ sender:UIPanGestureRecognizer) {
           let percentThreshold:CGFloat = 0.3
           let translation = sender.translation(in: view)

           let newX = ensureRange(value: view.frame.minY + translation.y, minimum: 0, maximum: view.frame.maxY)
           let progress = progressAlongAxis(newX, view.bounds.width)

           view.frame.origin.y = newX //Move view to new position

           if sender.state == .ended {
               let velocity = sender.velocity(in: view)
              if velocity.y >= 300 || progress > percentThreshold {
                  _ = navigationController?.popViewController(animated: true)
              } else {
                  UIView.animate(withDuration: 0.2, animations: {
                      self.view.frame.origin.y = 0 // Revert animation
                  })
             }
          }

          sender.setTranslation(.zero, in: view)
       }
    
    func progressAlongAxis(_ pointOnAxis: CGFloat, _ axisLength: CGFloat) -> CGFloat {
        let movementOnAxis = pointOnAxis / axisLength
        let positiveMovementOnAxis = fmaxf(Float(movementOnAxis), 0.0)
        let positiveMovementOnAxisPercent = fminf(positiveMovementOnAxis, 1.0)
        return CGFloat(positiveMovementOnAxisPercent)
    }

    func ensureRange<T>(value: T, minimum: T, maximum: T) -> T where T : Comparable {
        return min(max(value, minimum), maximum)
    }
    
    
    @objc fileprivate func imagesHandleRefresh() {
//        let element = image.remove(at: index)
//        image.insert(element, at: 0)
        let path = IndexPath(item: index, section: 0)
        imagesCollectionView.scrollToItem(at: path, at: .centeredHorizontally, animated: false)
        self.imagesCollectionView.reloadData()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return images
    }

    @objc func onDoubleTap(gestureRecognizer: UITapGestureRecognizer) {
        let scale = min(scroll.maximumZoomScale, scroll.maximumZoomScale)
        
        if scale != scroll.zoomScale {
            let point = gestureRecognizer.location(in: images)
            
            let scrollSize = scroll.frame.size
            let size = CGSize(width: scrollSize.width / scale,
                              height: scrollSize.height / scale)
            let origin = CGPoint(x: point.x - size.width / 2,
                                 y: point.y - size.height / 2)
            scroll.zoom(to:CGRect(origin: origin, size: size), animated: true)
            print(CGRect(origin: origin, size: size))
        }else if scale == scroll.maximumZoomScale{
            scroll.zoom(to:CGRect(origin: scroll.frame.origin, size: scroll.frame.size), animated: true)
        }
    }
    
    
    @IBAction func close(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
}

extension imagesViewer: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return image.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imagesCell", for: indexPath) as! imagesCell
        cell.configureCell(image: image[indexPath.item].image)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.size.width, height: collectionView.frame.height)
    }
    
}
