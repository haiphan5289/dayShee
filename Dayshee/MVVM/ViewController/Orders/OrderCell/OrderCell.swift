//
//  OrderCell.swift
//  Dayshee
//
//  Created by haiphan on 11/21/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxSwift

class OrderCell: UITableViewCell {

    var actionOrderDetail:(() -> Void)?
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbCode: UILabel!
    @IBOutlet weak var lbOrderDate: UILabel!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var btOrderDetail: HighlightedButton!
    private let disposeBag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.btOrderDetail.rx.tap.bind { _ in
            self.actionOrderDetail?()
        }.disposed(by: disposeBag)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
