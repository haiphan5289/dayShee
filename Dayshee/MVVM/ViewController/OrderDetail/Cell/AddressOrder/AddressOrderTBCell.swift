//
//  AddressOrderTBCell.swift
//  Dayshee
//
//  Created by Apple on 11/7/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit

class AddressOrderTBCell: UITableViewCell {

    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbPhone: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupDisplay(item: OrderInfo, list: [Location]) {
        self.lbName.text = item.name
        self.lbPhone.text = item.phone
        self.getZoneDetail(item: item, list: list)
    }
    private func getZoneDetail(item: OrderInfo, list: [Location]) {
        let zone = list.filter { $0.id == item.provinceID }.first
        
        guard let district = zone?.districts?.filter({ $0.id == item.districtID }).first else {
            lbAddress.text = "\(item.name ?? ""), \(zone?.province ?? "")"
            return
        }
        
        guard let ward = district.wards?.filter({ $0.id == item.wardID }).first else {
            lbAddress.text = "\(item.name ?? ""), \(zone?.province ?? "")  \(district.district ?? "")"
            return
        }
        
        lbAddress.text = "\(item.name ?? ""), \(ward.ward ?? ""), \(district.district ?? ""), \(zone?.province ?? "")"
        lbAddress.sizeToFit()
    }
    
}
