//
//  CategoryListCell.swift
//  Dayshee
//
//  Created by haiphan on 11/8/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit

class CategoryListCell: UICollectionViewCell {
    
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var leftText: NSLayoutConstraint!
    @IBOutlet weak var vLine: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        visualize()
    }

}
extension CategoryListCell {
    private func visualize() {

    }
}
