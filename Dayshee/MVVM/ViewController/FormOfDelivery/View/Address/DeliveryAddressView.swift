//
//  DeliveryAddressView.swift
//  Dayshee
//
//  Created by paxcreation on 11/13/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

typealias typeAddress = ((TypeAddressView, AddressModel?))

class DeliveryAddressView: UIView, UpdateDisplayProtocol, DisplayStaticHeightProtocol  {
    static var height: CGFloat { return 0 }
    static var bottom: CGFloat { return 0 }
    static var automaticHeight: Bool { return true }
    
    var moveToDeliveryAddress: (() -> Void)?
    var moveToListAddress: (() -> Void)?
    @IBOutlet weak var vUpdate: UIView!
    @IBOutlet weak var vChange: UIView!
    @IBOutlet weak var btChange: UIButton!
    @IBOutlet weak var btUpdate: UIButton!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbPhone: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    private let disposeBag = DisposeBag()
}
extension DeliveryAddressView: Weakifiable {
    override func awakeFromNib() {
        super.awakeFromNib()
        visualize()
        setupRX()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    override func removeFromSuperview() {
        superview?.removeFromSuperview()
    }
    
}
extension DeliveryAddressView {
    func setupDisplay(item: TypeAddressView?) {
        guard let item = item else {
            return
        }
        guard item == .change else {
            self.vChange .isHidden = true
            return
        }
        self.vUpdate.isHidden = true
    }
    
    private func setupRX() {
        self.btChange.rx.tap.bind { _ in
            self.moveToListAddress?()
        }.disposed(by: disposeBag)
        
        self.btUpdate.rx.tap.bind { _ in
            self.moveToDeliveryAddress?()
        }.disposed(by: disposeBag)
    }
    private func visualize() {
        lbAddress.text = ""
    }
    private func setupAddres(user: AddressModel) {
        self.lbName.text = user.name
        self.lbPhone.text = user.phone
        let location = user.province?.province ?? ""
        let d = user.district?.district ?? ""
        let w = user.ward?.ward ?? ""
        let address = user.address ?? ""
        self.lbAddress.text = "\(address), \(w), \(d), \(location)"
    }
    
    func setupDisplayView(item: typeAddress) {
        guard item.0 == .change else {
            self.vChange.isHidden = true
            self.vUpdate.isHidden = false
            return
        }
        self.vUpdate.isHidden = true
        self.vChange.isHidden = false
        guard  let user = item.1 else {
            return
        }
        self.setupAddres(user: user)
    }
}
