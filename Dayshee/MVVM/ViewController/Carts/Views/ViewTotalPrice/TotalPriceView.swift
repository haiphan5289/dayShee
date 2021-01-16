//
//  TotalPriceView.swift
//  Dayshee
//
//  Created by haiphan on 11/7/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class TotalPriceView: UIView, UpdateDisplayProtocol, DisplayStaticHeightProtocol {
    static var height: CGFloat { return 0 }
    static var bottom: CGFloat { return 0 }
    static var automaticHeight: Bool { return true }
    
    var textPromotion: ((String) -> Void)?
    var removeCode: (() -> Void)?
    var animateKeyboard:((KeyboardInfo?) -> Void)?
    var listDiscount: (() -> Void)?
    @IBOutlet weak var viewFeeShip: UIView!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var lbPriceTemp: UILabel!
    @IBOutlet weak var lbDiscountPrice: UILabel!
    @IBOutlet weak var lbDiscount: UILabel!
    @IBOutlet weak var lbFreeShip: UILabel!
    @IBOutlet weak var btApply: UIButton!
    @IBOutlet weak var tfPromotionCode: UITextField!
    @IBOutlet weak var btRemoveCode: UIButton!
    @IBOutlet weak var vPromotion: UIView!
    @IBOutlet weak var btListDiscount: UIButton!
    private let disposeBag = DisposeBag()
}
extension TotalPriceView: Weakifiable {
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
extension TotalPriceView {
    func setupDisplay(item: Product?) {
        guard let item = item else {
            return
        }
        
    }
    
    private func setupRX() {
        self.btApply.rx.tap.bind { [weak self] _ in
            guard let wSelf = self, let text = wSelf.tfPromotionCode.text else {
                return
            }
            wSelf.textPromotion?(text)
        }.disposed(by: disposeBag)
        
        self.btRemoveCode.rx.tap.bind { _ in
            self.removeCode?()
        }.disposed(by: disposeBag)
        
        self.btListDiscount.rx.tap.bind { _ in
            self.listDiscount?()
        }.disposed(by: disposeBag)
        
        
        let show = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification).map { KeyboardInfo($0) }
        let hide = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification).map { KeyboardInfo($0) }
        
        Observable.merge(show, hide).bind(onNext: weakify({ (keyboard, wSelf) in
            wSelf.animateKeyboard?(keyboard)
        })).disposed(by: disposeBag)
       
    }
    func setupDiscount(total: Double, promotionCode: PromotionModel?, feeShip: Double = 0) {
        guard let promotionCode = promotionCode  else {
            let final = total 
            self.lbDiscount.text = ""
            self.totalPrice.text = final.currency
            self.lbDiscountPrice.text = 0.currency
            self.tfPromotionCode.text = ""
            self.lbPriceTemp.text = total.currency
            self.btRemoveCode.setTitle("", for: .normal)
            return
        }
        self.lbPriceTemp.text = total.currency
        if let d = promotionCode.discount {
            self.btRemoveCode.setTitle("Xoá mã", for: .normal)
            let discount = (d * 100) / 1
            let priceDiscount = total - (total * d)
            let final = priceDiscount
            self.lbDiscount.text = "\(discount) %"
            self.totalPrice.text = final.currency
            self.lbDiscountPrice.text = (total * d).currency
        }
    }
    func updateUITotalPrice(cartDetail: CartModelDetail) {
        lbPriceTemp.text = cartDetail.subTotal?.currency
        lbDiscountPrice.text = cartDetail.discountMoney?.currency
        totalPrice.text = cartDetail.total?.currency
        if let discount = cartDetail.promotionPercent, discount > 0 {
            lbDiscount.text = "\(discount) %"
        } else {
            lbDiscount.text = ""
        }
        
    }

    private func visualize() {
        self.lbDiscount.text = ""
        self.tfPromotionCode.becomeFirstResponder()
    }
    func removeView(views: [UIView]) {
        views.forEach { (v) in
            v.isHidden = true
        }
    }
    func setupColorLabelTotapPrice() {
        self.totalPrice.textColor = UIColor(named: "ColorApp")
    }
    func hideButtonRemove() {
        self.btRemoveCode.isHidden = true
    }
    func setupUIFromOrderDetail(item: OrderInfo) {
        self.lbPriceTemp.text = item.subTotal?.currency
        self.lbFreeShip.text = "Miễn phí"
        self.lbDiscountPrice.text = item.promotionMoney?.currency
        self.totalPrice.text = item.total?.currency
        if let percent = item.promotionPercent {
            self.lbDiscount.text = (percent > 0) ? "\(percent)%" : ""
        } else {
            self.lbDiscount.text = ""
        }
    }
}
