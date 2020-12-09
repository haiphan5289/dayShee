//
//  ListFavouriteCell.swift
//  Dayshee
//
//  Created by paxcreation on 11/17/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit

class ListFavouriteCell: UITableViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func actionRemove(_ sender: UIButton) {
    }
}
