//
//  OrderCell.swift
//  Dayshee
//
//  Created by haiphan on 11/21/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {

    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbCode: UILabel!
    @IBOutlet weak var lbOrderDate: UILabel!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var lbName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
