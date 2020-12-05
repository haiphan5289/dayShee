//
//  OrderView.swift
//  Dayshee
//
//  Created by paxcreation on 11/13/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class OrderView: UIView, UpdateDisplayProtocol, DisplayStaticHeightProtocol {
    static var height: CGFloat { return 0 }
    static var bottom: CGFloat { return 0 }
    static var automaticHeight: Bool { return true }
    
    @IBOutlet weak var stackView: UIStackView!
    @Replay(queue: MainScheduler.asyncInstance) var listOrder: [HomeDetailModel]
    private let disposeBag = DisposeBag()
}
extension OrderView: Weakifiable {
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
extension OrderView {
    func setupDisplay(item: [HomeDetailModel]?) {
        guard let item = item else {
            return
        }
    }
    
    private func setupRX() {
        self.$listOrder.take(1).asObservable().bind(onNext: weakify({ (list, wSelf) in
            wSelf.setupStackView(list: list)
        })).disposed(by: disposeBag)
       
    }
    private func visualize() {
        
    }
    private func setupStackView(list: [HomeDetailModel]) {
        for (index, element) in list.enumerated() {
            let v: UIView = UIView(frame: .zero)
            
            let lbPrice: UILabel = UILabel(frame: .zero)
            lbPrice.textColor = .black
            lbPrice.font = UIFont.systemFont(ofSize: 13)
            lbPrice.text = element.maxPrice?.currency
            v.addSubview(lbPrice)
            lbPrice.snp.makeConstraints { (make) in
                make.right.equalToSuperview()
                make.width.greaterThanOrEqualTo(50)
            }
            
            let lbName: UILabel = UILabel(frame: .zero)
            lbName.textColor = .black
            lbName.font = UIFont.systemFont(ofSize: 13)
            lbName.text = "\(element.count ?? 0) x \(element.name ?? "") - \(element.size ?? "") "
            lbName.numberOfLines = 0
            lbName.sizeToFit()
            v.addSubview(lbName)
            lbName.snp.makeConstraints { (make) in
                make.top.equalToSuperview()
                make.left.equalToSuperview().inset(40)
                make.right.equalTo(lbPrice.snp.left).inset(-10)
                make.bottom.equalToSuperview().inset(5)
                make.height.greaterThanOrEqualTo(30)
            }
            
            let img: UIImageView = UIImageView(frame: .zero)
            v.addSubview(img)
            img.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.height.width.equalTo(30)
                make.centerY.equalTo(lbName)
            }
            if let textUrl = element.imageURL, let url = URL(string: textUrl)  {
                img.kf.setImage(with: url)
            }

            lbPrice.snp.makeConstraints { (make) in
                make.centerY.equalTo(lbName)
            }
            
            stackView.addArrangedSubview(v)
        }
    }
}

