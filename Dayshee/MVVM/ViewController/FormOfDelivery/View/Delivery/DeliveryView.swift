//
//  DeliveryView.swift
//  Dayshee
//
//  Created by paxcreation on 11/13/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class DeliveryView: UIView, UpdateDisplayProtocol, DisplayStaticHeightProtocol  {
    static var height: CGFloat { return 0 }
    static var bottom: CGFloat { return 0 }
    static var automaticHeight: Bool { return true }
    
    var shipMode:((DeliveryMode) -> Void)?
    @IBOutlet weak var stackView: UIStackView!
    private var views: [UIImageView] = []
    private let disposeBag = DisposeBag()
}
extension DeliveryView: Weakifiable {
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
extension DeliveryView {
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
        for (index, element) in list.enumerated() {
            let v: UIView = UIView(frame: .zero)
            v.tag = element.id ?? 0
            let img: UIImageView = UIImageView(frame: .zero)
            img.tag = element.id ?? 0
            img.clipsToBounds = true
            img.layer.cornerRadius = 10
            img.layer.borderWidth = 1
            img.layer.borderColor = (index == 0) ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
            img.backgroundColor = (index == 0) ? .black : .white
            v.addSubview(img)
            img.snp.makeConstraints { (make) in
                make.top.left.equalToSuperview()
                make.height.width.equalTo(20)
            }
        
            let lbName: UILabel = UILabel(frame: .zero)
            lbName.textColor = .black
            lbName.font = UIFont(name: "Montserrat-Regular", size: 12.0)
            lbName.text = "\(element.delivery ?? "")  (\(element.time ?? ""))"
            lbName.numberOfLines = 0
            v.addSubview(lbName)
            lbName.snp.makeConstraints { (make) in
                make.top.equalTo(img)
                make.left.equalTo(img.snp.right).inset(-10)
                make.right.equalToSuperview().inset(10)
            }
            
            let lbPrice: UILabel = UILabel(frame: .zero)
            lbPrice.textColor = .black
            lbPrice.font = UIFont(name: "Montserrat-SemiBold", size: 12.0) 
            lbPrice.text = element.price?.currency
            v.addSubview(lbPrice)
            lbPrice.snp.makeConstraints { (make) in
                make.right.equalToSuperview()
                make.top.equalTo(lbName.snp.bottom).inset(-10)
                make.left.equalTo(lbName)
                make.bottom.equalToSuperview().inset(5)
            }
            
            let tap: UITapGestureRecognizer = UITapGestureRecognizer()
            v.addGestureRecognizer(tap)
            
            tap.rx.event.asObservable().bind { _ in
                self.views.forEach { (v) in
                    v.backgroundColor = (v.tag == element.id) ? .black : .white
                    v.layer.borderColor = (v.tag == element.id) ?  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) :  #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
                }
                self.shipMode?(element)
            }.disposed(by: disposeBag)
            
            self.views.append(img)
            stackView.addArrangedSubview(v)
        }
    }
}
