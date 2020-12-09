//
//  RowCellRegister.swift
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

class FinalCellRegister: Eureka.Cell<String>, CellType, UITextFieldDelegate, UpdateDisplayProtocol {
    let lbTitle: UILabel = UILabel(frame: .zero)
    let tfSub: UITextField = UITextField(frame: .zero)
    let img: UIImageView = UIImageView(frame: .zero)
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
        contentView.addSubview(lbTitle)
        lbTitle.text = "Họ tên"
        lbTitle.textAlignment = .left
        lbTitle.font = UIFont(name: "Montserrat-Regular", size: 13.0)
        lbTitle.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.left.right.equalTo(55)
        }
        
        contentView.addSubview(tfSub)
        tfSub.placeholder = "Nhập họ tên"
        tfSub.font = UIFont(name: "Montserrat-Regular", size: 13.0)
        tfSub.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: tfSub.frame.height))
        tfSub.rightViewMode = .always
        tfSub.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(55)
            make.top.equalTo(self.lbTitle.snp.bottom).inset(-10)
        }
        
        tfSub.addSubview(self.img)
        img.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        let vLine: UIView = UIView(frame: .zero)
        vLine.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 1)
        contentView.addSubview(vLine)
        vLine.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.tfSub)
            make.top.equalTo(self.tfSub.snp.bottom).inset(-5)
            make.height.equalTo(1)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    private func setupRX() {
        tfSub.delegate = self
        tfSub.addTarget(self, action: #selector(textChanged(sender:)), for: .valueChanged)
        tfSub.addTarget(self, action: #selector(textChanged(sender:)), for: .editingChanged)
        tfSub.addTarget(self, action: #selector(textChanged(sender:)), for: .editingDidEnd)
        tfSub.addTarget(self, action: #selector(textChanged(sender:)), for: .editingDidBegin)
    }
    
    func updateUI(title: String, placeHolder: String) {
        self.lbTitle.text = title
        self.tfSub.placeholder = placeHolder
    }
    @objc func textChanged(sender: UITextField?) {
        row.value = sender?.text
        row.validate()
    }
    
    func setupDisplay(item: String?) {
       tfSub.text = item
        row.value = item
        row.validate()
    }
    
    override func cellResignFirstResponder() -> Bool {
        return tfSub.resignFirstResponder()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        formViewController()?.endEditing(of: self)
        formViewController()?.textInputDidEndEditing(textField, cell: self)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return formViewController()?.textInputShouldEndEditing(textField, cell: self) ?? true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return formViewController()?.textInputShouldClear(textField, cell: self) ?? true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return formViewController()?.textInputShouldReturn(textField, cell: self) ?? true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return formViewController()?.textInput(textField, shouldChangeCharactersInRange: range, replacementString: string, cell: self) ?? true
    }
}

