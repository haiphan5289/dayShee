//
//  DeliveryCell.swift
//  Dayshee
//
//  Created by paxcreation on 11/17/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit

class DeliveryCell: UITableViewCell {

    var deleteAddress: (() -> Void)?
    var updateDefaultAddress: (() -> Void)?
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbPhone: UILabel!
    @IBOutlet weak var lbContent: UILabel!
    @IBOutlet weak var vCheck: UIView!
    @IBOutlet weak var btSetDefault: UIButton!
    @IBOutlet weak var imgCheck: UIImageView!
    @IBOutlet weak var bottomButton: NSLayoutConstraint!
    @IBOutlet weak var bottomContent: NSLayoutConstraint!
    @IBOutlet weak var btClose: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func actionClose(_ sender: UIButton) {
        self.deleteAddress?()
    }
    
    @IBAction func updateDefault(_ sender: UIButton) {
        self.updateDefaultAddress?()
    }
}
