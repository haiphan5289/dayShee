//
//  DefaultView.swift
//  Dayshee
//
//  Created by haiphan on 11/14/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Eureka

class DefaultView: Eureka.Cell<Bool>, CellType, UpdateDisplayProtocol {
    
    var isSetDefault:((Bool) -> Void)?
    private let btDefaultValue: UIButton = UIButton(type: .custom)
    private let lbSub: UILabel = UILabel(frame: .zero)
    private let disposeBag = DisposeBag()
    required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupRX()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI() {
        selectionStyle = .none
        self.backgroundColor = .clear
        
        btDefaultValue.clipsToBounds = true
        btDefaultValue.backgroundColor = .white
        btDefaultValue.layer.borderWidth = 0.5
        btDefaultValue.layer.borderColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
        btDefaultValue.layer.cornerRadius = 7.5
        btDefaultValue.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 13.0)
        contentView.addSubview(btDefaultValue)
        btDefaultValue.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(55)
            make.top.equalToSuperview().inset(15)
            make.height.width.equalTo(15)
            make.bottom.equalToSuperview().inset(5)
        }
        
        lbSub.text = "Đặt làm địa chỉ mặc định"
        lbSub.font = UIFont(name: "Montserrat-Regular", size: 13.0)
        lbSub.textColor = .black
        contentView.addSubview(lbSub)
        lbSub.snp.makeConstraints { (make) in
            make.centerY.equalTo(btDefaultValue)
            make.left.equalTo(btDefaultValue.snp.right).inset(-10)
        }
        
    }
    
    private func setupRX() {
        btDefaultValue.rx.tap.bind { _ in
            if self.btDefaultValue.isSelected {
                self.btDefaultValue.isSelected = false
                self.btDefaultValue.backgroundColor = .white
                self.isSetDefault?(false)
            } else {
                self.btDefaultValue.isSelected = true
                self.btDefaultValue.backgroundColor = .black
                self.isSetDefault?(true)
            }
        }.disposed(by: disposeBag)
    }
    
    func updateUI(title: String, placeHolder: String) {
//        self.lbTitle.text = title
//        self.tfSub.placeholder = placeHolder
    }
    @objc func textChanged(sender: UITextField?) {
//        row.value = sender?.text
        row.validate()
    }
    
    func setupDisplay(item: Bool?) {
        guard let isSetdefault = item else {
            return
        }
        if isSetdefault {
            self.btDefaultValue.isSelected = true
            self.btDefaultValue.backgroundColor = .black
        } else {
            self.btDefaultValue.isSelected = false
            self.btDefaultValue.backgroundColor = .white
        }
        row.value = item
    }
}
