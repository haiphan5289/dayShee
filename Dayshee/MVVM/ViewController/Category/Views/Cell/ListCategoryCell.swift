//
//  ListCategoryCell.swift
//  Dayshee
//
//  Created by haiphan on 11/7/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit

class ListCategoryCell: UICollectionViewCell {

    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbPriceDiscount: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var leftArea: NSLayoutConstraint!
    @IBOutlet weak var rightArea: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
