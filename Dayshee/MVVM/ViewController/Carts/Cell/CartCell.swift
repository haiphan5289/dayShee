//
//  CartCell.swift
//  Dayshee
//
//  Created by paxcreation on 11/6/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit

class CartCell: UITableViewCell {

    let viewCell: TotalPriceView = TotalPriceView.loadXib()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.addSubview(viewCell)
        viewCell.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
