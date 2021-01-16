//
//  ProductViewCell.swift
//  Dayshee
//
//  Created by paxcreation on 11/6/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit

class ProductViewCell: UICollectionViewCell {

    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbPriceDiscount: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var viewBorder: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.applyShadowAndRadius(sizeX: 0, sizeY: 3, shadowRadius: 6, shadowColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.16))
        viewBorder.layer.cornerRadius = 10
    }

}
