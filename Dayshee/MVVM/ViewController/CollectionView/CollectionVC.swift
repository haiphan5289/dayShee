//
//  CollectionVC.swift
//  MVVM_2020
//
//  Created by Admin on 9/21/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit

class CollectionVC: UIViewController {
    @IBOutlet weak var collectionView1: UICollectionView!
    @IBOutlet weak var collectionView2: UICollectionView!

    var mang: [String] = ["Combo 1 người", "Combo nhóm", "Combo ưu đãi", "Khuyễn mãi", "Món lẻ"]
    var mang_hinh:[UIImage] = [#imageLiteral(resourceName: "tvstands"),#imageLiteral(resourceName: "6796")]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        collectionView1.delegate = self
        collectionView1.dataSource = self
        collectionView2.delegate = self
        collectionView2.dataSource = self
    }
    
    
}


extension CollectionVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //Số cell
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionView1{
            return mang.count
        }
        if collectionView == collectionView2 {
            return mang_hinh.count
        }
        return 0
    }
    
    //Sẽ load các cell nào
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if  collectionView == collectionView1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCLCell", for: indexPath)
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell2", for: indexPath) as! CustomCell2
            cell.imgView.image = mang_hinh[indexPath.row]
            return cell
        }
      
    }
    
    //Quy định size cho collectionview cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionView1 {
            return CGSize(width: 80, height: 40)
        }
        return CGSize(width: 320, height: 200)
    }
    // Khoảng cách trên dưới trái phải so với parent view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    //khoảng cách các dòng
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    // Khoảng cách item
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
class CustomCLCell: UICollectionViewCell {
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var viewParent: UIView!
    
}
class CustomCLCell2: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    
}
