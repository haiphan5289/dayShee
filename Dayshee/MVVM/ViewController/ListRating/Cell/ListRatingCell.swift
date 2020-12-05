//
//  ListRatingCell.swift
//  Dayshee
//
//  Created by haiphan on 11/12/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import Cosmos

class ListRatingCell: UITableViewCell {

    @IBOutlet weak var lbContent: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var viewRating: CosmosView!
    @IBOutlet weak var lbTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
