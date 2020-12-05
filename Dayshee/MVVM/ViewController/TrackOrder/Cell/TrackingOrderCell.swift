//
//  TrackingOrderCell.swift
//  Dayshee
//
//  Created by haiphan on 11/21/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class TrackingOrderCell: UITableViewCell {

    @IBOutlet weak var vCurrentStatus: UIView!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var vVertical: UIView!
    @IBOutlet weak var lbTime: UILabel!
    private let disposeBag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
