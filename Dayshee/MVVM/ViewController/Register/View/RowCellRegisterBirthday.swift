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

class RowCellRegisterBirthday: Eureka.Cell<String>, CellType, UITextFieldDelegate, UpdateDisplayProtocol {
    func setupDisplay(item: String?) {
    }
    let lbTitle: UILabel = UILabel(frame: .zero)
    let tfSub: UITextField = UITextField(frame: .zero)
    let img: UIImageView = UIImageView(image: UIImage(named: "ic_calendar"))
    let datePicker = UIDatePicker()
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
        contentView.addSubview(lbTitle)
        lbTitle.text = "Ngày sinh"
        lbTitle.textAlignment = .left
        lbTitle.font = UIFont(name: "Montserrat-Regular", size: 13.0)
        lbTitle.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.left.right.equalTo(55)
        }
        
        contentView.addSubview(tfSub)
        tfSub.placeholder = "Chọn ngày sinh"
        let colorWard = UIColor.black
        let placeholderWard = tfSub.placeholder ?? "" //There should be a placeholder set in storyboard or elsewhere string or pass empty
        tfSub.attributedPlaceholder = NSAttributedString(string: placeholderWard, attributes: [NSAttributedString.Key.foregroundColor : colorWard])
        tfSub.font = UIFont(name: "Montserrat-Regular", size: 13.0)
        tfSub.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: tfSub.frame.height))
        tfSub.leftViewMode = .always
        tfSub.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(55)
            make.top.equalTo(self.lbTitle.snp.bottom).inset(-10)
        }
        
        tfSub.addSubview(self.img)
        img.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
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
        
        //Formate Date
        datePicker.datePickerMode = .dateAndTime
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let bOK: UIButton = UIButton(type: .custom)
        bOK.setTitle("Done", for: .normal)
        bOK.setTitleColor(.black, for: .normal)
        let doneButton = UIBarButtonItem(customView: bOK)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([doneButton,spaceButton], animated: false)
        tfSub.inputAccessoryView = toolbar
        tfSub.inputView = datePicker
        
        bOK.rx.tap.bind { [weak self] _ in
            guard let wSelf = self else {
                return
            }
            wSelf.tfSub.text = wSelf.datePicker.date.string(from: "yyyy-mm-dd")
            wSelf.endEditing(true)
        }.disposed(by: disposeBag)
        
    }
    
    private func setupRX() {
        tfSub.delegate = self
        tfSub.addTarget(self, action: #selector(textChanged(sender:)), for: .valueChanged)
        tfSub.addTarget(self, action: #selector(textChanged(sender:)), for: .editingChanged)
        tfSub.addTarget(self, action: #selector(textChanged(sender:)), for: .editingDidEnd)
        tfSub.addTarget(self, action: #selector(textChanged(sender:)), for: .editingDidBegin)
    }
    
    @objc func textChanged(sender: UITextField?) {
        row.value = sender?.text
        row.validate()
    }
    
    func updateUI(title: String, placeHolder: String, img: String?, hideImg: Bool?) {
        self.lbTitle.text = title
        self.tfSub.placeholder = placeHolder
        self.img.image = UIImage(named: img ?? "")
        self.img.isHidden = hideImg ?? true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}

