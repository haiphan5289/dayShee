//
//  InforOrderTBCell.swift
//  Dayshee
//
//  Created by Apple on 11/7/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit

class InforOrderTBCell: BaseTableViewCell {

    var actionNext: (() -> Void)?
    @IBOutlet weak var lbCode: UILabel!
    @IBOutlet weak var lbDateOrder: UILabel!
    @IBOutlet weak var lbStatus: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        
    }

    @IBAction func btnNext(_ sender: Any) {
        actionNext?()
    }
    func setupInfoOrder(item: OrderInfo) {
        self.lbCode.text = "\(item.id ?? 0)"
        self.lbDateOrder.text = item.createdAt
        guard let stt = item.orderStatus?.status, let textStt = StatusOrder(rawValue: stt) else {
            return
        }
        self.lbStatus.text = textStt.textStatus
    }
    
}
