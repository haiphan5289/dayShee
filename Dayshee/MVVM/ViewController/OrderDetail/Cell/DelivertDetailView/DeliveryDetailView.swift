//
//  DeliveryDetailView.swift
//  Dayshee
//
//  Created by haiphan on 11/21/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//
import UIKit
import RxCocoa
import RxSwift

class DeliveryDetailView: UIView, UpdateDisplayProtocol, DisplayStaticHeightProtocol  {
    static var height: CGFloat { return 0 }
    static var bottom: CGFloat { return 0 }
    static var automaticHeight: Bool { return true }
    
    var shipMode:((DeliveryMode) -> Void)?
    @IBOutlet weak var stackView: UIStackView!
    private var views: [UIImageView] = []
    private let disposeBag = DisposeBag()
}
extension DeliveryDetailView: Weakifiable {
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
extension DeliveryDetailView {
    func setupDisplay(item: [DeliveryMode]?) {
        guard let item = item else {
            return
        }
        setupStackView(list: item)
    }
    
    private func setupRX() {
       
    }
    private func visualize() {
        
    }
    private func setupStackView(list: [DeliveryMode]) {
        stackView.removeSubviews()
        for (_, element) in list.enumerated() {
            let v: UIView = UIView(frame: .zero)
            v.tag = element.id ?? 0
            
            let lbPrice: UILabel = UILabel(frame: .zero)
            lbPrice.textColor = .black
            lbPrice.font = UIFont(name: "Montserrat-Medium", size: 13.0)
            lbPrice.text = element.price?.currency
            v.addSubview(lbPrice)
            lbPrice.snp.makeConstraints { (make) in
                make.right.equalToSuperview()
                make.top.equalToSuperview()
            }
            
            let lbName: UILabel = UILabel(frame: .zero)
            lbName.textColor = .black
            lbName.font = UIFont(name: "Montserrat-Regular", size: 13.0)
            lbName.text = "\(element.delivery ?? "")  (\(element.time ?? ""))"
            lbName.numberOfLines = 0
            v.addSubview(lbName)
            lbName.snp.makeConstraints { (make) in
                make.top.left.equalToSuperview()
                make.right.equalTo(lbPrice.snp.left).inset(10)
                make.bottom.equalToSuperview().inset(10)
            }
            

                        
            stackView.addArrangedSubview(v)
        }
    }
}
