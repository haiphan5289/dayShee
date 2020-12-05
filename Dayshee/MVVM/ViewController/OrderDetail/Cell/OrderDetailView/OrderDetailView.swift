//
//  OrderDetailView.swift
//  Dayshee
//
//  Created by haiphan on 11/21/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class OrderDetailView: UIView, UpdateDisplayProtocol, DisplayStaticHeightProtocol {
    static var height: CGFloat { return 0 }
    static var bottom: CGFloat { return 0 }
    static var automaticHeight: Bool { return true }
    
    var updateCell: (() -> Void)?
    @IBOutlet weak var stackView: UIStackView!
    @Replay(queue: MainScheduler.asyncInstance) var listOrder: [OrderDetail]
    private let disposeBag = DisposeBag()
}
extension OrderDetailView: Weakifiable {
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
extension OrderDetailView {
    func setupDisplay(item: [OrderDetail]?) {
        guard let item = item else {
            return
        }
        self.listOrder = item
    }
    
    private func setupRX() {
        self.$listOrder.take(1).asObservable().bind(onNext: weakify({ (list, wSelf) in
            wSelf.setupStackView(list: list)
        })).disposed(by: disposeBag)
       
    }
    private func visualize() {
        
    }
    private func setupStackView(list: [OrderDetail]) {
        for (_, element) in list.enumerated() {
            let v: UIView = UIView(frame: .zero)

            let lbPrice: UILabel = UILabel(frame: .zero)
            lbPrice.textColor = .black
            lbPrice.font = UIFont.systemFont(ofSize: 13)
            lbPrice.text = element.price?.currency
            lbPrice.textAlignment = .right
            v.addSubview(lbPrice)
            lbPrice.snp.makeConstraints { (make) in
                make.right.equalToSuperview()
                make.width.greaterThanOrEqualTo(50)
            }
            
            let lbName: UILabel = UILabel(frame: .zero)
            lbName.textColor = .black
            lbName.font = UIFont.systemFont(ofSize: 13)
            lbName.text = "\(Int(element.quantity ?? 0)) x \(element.product?.name ?? "")"
            lbName.numberOfLines = 0
            lbName.textAlignment = .left
            v.addSubview(lbName)
            lbName.snp.makeConstraints { (make) in
                make.bottom.left.equalToSuperview()
                make.top.equalToSuperview().inset(5)
                make.right.equalTo(lbPrice.snp.left).inset(-10)
            }
            lbPrice.snp.makeConstraints { (make) in
                make.centerY.equalTo(lbName)
            }
            
            stackView.addArrangedSubview(v)
        }
        self.updateCell?()
    }
}

