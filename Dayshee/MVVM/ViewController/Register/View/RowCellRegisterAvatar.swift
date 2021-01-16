//
//  RowCellRegisterAvatar.swift
//  Dayshee
//
//  Created by haiphan on 10/31/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import Eureka
import SnapKit
import RxCocoa
import RxSwift

class RowCellRegisterAvatar: Eureka.Cell<Bool>, CellType, UITextFieldDelegate, UpdateDisplayProtocol {
    func setupDisplay(item: Bool?) {
    }
    var presentImage: (() -> Void)?
    let imgAvatar: UIImageView = UIImageView(frame: .zero)
    let imgCircle: UIImageView = UIImageView(frame: .zero)
    private let lbTitle: UILabel = UILabel(frame: .zero)
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
        self.backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(imgCircle)
        imgCircle.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(55)
            make.top.bottom.equalToSuperview()
            make.width.height.equalTo(90)
        }
        
        imgCircle.addSubview(imgAvatar)
        imgCircle.clipsToBounds = true
        imgCircle.layer.cornerRadius = 45
        imgAvatar.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        contentView.addSubview(lbTitle)
        lbTitle.font = UIFont(name: "Montserrat-Regular", size: 12.0)
        lbTitle.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(55)
            make.centerY.equalTo(self.imgAvatar)
        }
        
        let b: UIButton = UIButton(type: .custom)
        contentView.addSubview(b)
        b.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        b.rx.tap.bind { _ in
            self.presentImage?()
        }.disposed(by: disposeBag)
    }
    
    private func setupRX() {
    }
    
    func updateUI(title: String, imageCircle: String, imageAvatar: String) {
        self.lbTitle.text = title
        self.imgCircle.image = UIImage(named: imageCircle)
        self.imgAvatar.image = UIImage(named: imageAvatar)
    }
}
