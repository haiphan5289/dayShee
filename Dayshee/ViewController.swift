//
//  ViewController.swift
//  keeng_customer
//
//  Created by ThanhPham on 10/24/18.
//  Copyright © 2018 ThanhPham. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: IBOUTLETS
    
    //MARK: OTHER VARIABLES
    
    
    //MARK: VIEW LIFE CYCLE
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupVar()
        setupUI()
        callAPI()
    }
    
    //MARK: - SETUP UI & VAR
    func setupVar() {
        
    }
    
    func setupUI() {
        
    }
    
    //MARK - CALL API
    func callAPI() {
        
        fillData()
    }
    
    //MARK: - FILL DATA
    func fillData() {
        
    }
    
    //MARK: - BUTTON ACTIONS
    
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentTBcell", for: indexPath) as! ContentTBcell
        return cell
    }
}


class HeaderCell: UITableViewCell {
    @IBOutlet weak var collectionView1: UICollectionView!

    var mang: [String] = ["Combo 1 người", "Combo nhóm", "Combo ưu đãi", "Khuyễn mãi", "Món lẻ"]
}
extension HeaderCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mang.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: CollectionViewCell.self, for: indexPath)
        return cell
    }
    
}

class ContentTBcell: UITableViewCell {
    @IBOutlet weak var collectionView2: UICollectionView!
    var mang_hinh:[UIImage] = [#imageLiteral(resourceName: "tvstands"),#imageLiteral(resourceName: "6796")]

}
extension ContentTBcell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mang_hinh.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: CollectionViewCell2.self, for: indexPath)
        return cell
    }
    
}
class CollectionViewCell: UICollectionViewCell {
    
}

class CollectionViewCell2: UICollectionViewCell {
    
}
