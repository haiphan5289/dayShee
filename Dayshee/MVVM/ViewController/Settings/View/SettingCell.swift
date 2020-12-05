//
//  SettingCell.swift
//  Dayshee
//
//  Created by haiphan on 11/1/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit

class SettingCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var imgArrow: UIImageView!
    @IBOutlet weak var lbText: UILabel!
    @IBOutlet weak var lbVersion: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
