//
//  ProductCartView.swift
//  Dayshee
//
//  Created by haiphan on 11/7/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

enum TypeAddCart {
    case add
    case remove
}

class ProductCartView: UIView, UpdateDisplayProtocol, DisplayStaticHeightProtocol {
    static var height: CGFloat { return 0 }
    static var bottom: CGFloat { return 0 }
    static var automaticHeight: Bool { return true }
    
    var countProduct: ((TypeAddCart, Double) -> Void)?
    var countProductCheck: ((Double) -> Void)?
    var deleteRow: (() -> Void)?
    @IBOutlet weak var btPlus: UIButton!
    @IBOutlet weak var btMinus: UIButton!
    @IBOutlet weak var lbAmount: UILabel!
    @IBOutlet weak var btClose: UIButton!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    
    private var priceProduct: Double = 0
    private var item: HomeDetailModel?
    private let disposeBag = DisposeBag()
    
}
extension ProductCartView: Weakifiable {
    override func awakeFromNib() {
        super.awakeFromNib()
        setupRX()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        visualize()
    }
    override func removeFromSuperview() {
        superview?.removeFromSuperview()
    }
    
}
extension ProductCartView {
    func setupDisplay(item: HomeDetailModel?) {
        guard let item = item, let count = item.count else {
            return
        }
        self.item = item
        self.lbAmount.text = (count >= 10) ? "\(count)" : "0\(count)"
        self.lbName.text = "\(item.name ?? "") - \(item.size ?? "")"
        self.lbPrice.text = (item.productOtionPrice ?? 00).currency
        self.priceProduct = item.maxPrice ?? 0
        guard let textUrl = item.imageURL, let url = URL(string: textUrl) else {
            return
        }
        img.kf.setImage(with: url)
    }
    
    private func setupRX() {
        let add = btPlus.rx.tap.map { TypeAddCart.add }
        let remove = btMinus.rx.tap.map { TypeAddCart.remove }
        Observable.merge(add, remove).bind { [weak self] (type) in
            guard let wSelf = self, let item = wSelf.item else {
                return
            }
            if type == .remove && (item.count ?? 0) <= 1 {
                return
            }
            (type == .add) ? RealmManager.shared.insertOrUpdateProduct(model: item, count: 1) : RealmManager.shared.insertOrUpdateProduct(model: item, count: -1)
            guard let count = wSelf.item?.count else {
                return
            }
            wSelf.lbAmount.text = (count < 10) ? "0\(count)" : "\(count)"
        }.disposed(by: disposeBag)
        
        btClose.rx.tap.bind { [weak self] in
            guard let wSelf = self else {
                return
            }
            wSelf.deleteRow?()
        }.disposed(by: disposeBag)
    }
    private func visualize() {
    }
    func setupUI(title: String, hidenImage: Bool) {
    }
}
