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

class RowCellRegisterCity: Eureka.Cell<Int>, CellType, UITextFieldDelegate, UpdateDisplayProtocol {
    func setupDisplay(item: Int?) {
        
    }
    
    let lbTitle: UILabel = UILabel(frame: .zero)
    let tfSub: UITextField = UITextField(frame: .zero)
    let img: UIImageView = UIImageView(frame: .zero)
    var dataSource: BehaviorRelay<[Location]> = BehaviorRelay.init(value: [])
    var locationID: PublishSubject<Int> = PublishSubject.init()
    private var pickerView: UIPickerView = UIPickerView()
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
        self.tfSub.inputView = pickerView
        contentView.addSubview(lbTitle)
        lbTitle.text = "Họ tên"
        lbTitle.textAlignment = .left
        lbTitle.font = UIFont(name: "Montserrat-Regular", size: 13.0)
        lbTitle.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.left.right.equalTo(55)
        }
        
        contentView.addSubview(tfSub)
        let colorDistrict = UIColor.black
        tfSub.placeholder = "Chọn"
        let placeholderDistrict = tfSub.placeholder ?? "" //There should be a placeholder set in storyboard or elsewhere string or pass empty
        tfSub.attributedPlaceholder = NSAttributedString(string: placeholderDistrict, attributes: [NSAttributedString.Key.foregroundColor : colorDistrict])
        tfSub.font = UIFont(name: "Montserrat-Regular", size: 13.0)
        tfSub.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: tfSub.frame.height))
        tfSub.rightViewMode = .always
        tfSub.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(55)
            make.top.equalTo(self.lbTitle.snp.bottom).inset(-10)
        }
        
        tfSub.addSubview(self.img)
        img.image = UIImage(named: "ic_chevron_right")
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
        
//        tfSub.addTarget(self, action: #selector(textChanged(sender:)), for: .valueChanged)
//        tfSub.addTarget(self, action: #selector(textChanged(sender:)), for: .editingChanged)
//        tfSub.addTarget(self, action: #selector(textChanged(sender:)), for: .editingDidEnd)
//        tfSub.addTarget(self, action: #selector(textChanged(sender:)), for: .editingDidBegin)
        
        dataSource.bind(to: pickerView.rx.itemTitles) { (row, element) in
            return element.province
        }.disposed(by: disposeBag)
        
        pickerView.rx.itemSelected
            .bind(onNext: { [weak self] (row, element) in
                guard let wSelf = self else {
                    return
                }
                guard wSelf.dataSource.value.count > 0 else {
                    return
                }
                wSelf.tfSub.text = wSelf.dataSource.value[row].province
                wSelf.row.value = wSelf.dataSource.value[row].id
                wSelf.locationID.onNext(wSelf.dataSource.value[row].id ?? 0)
                wSelf.row.validate()
//                wSelf.idLocation = row
                wSelf.endEditing(true)
            })
            .disposed(by: disposeBag)
    }
//    @objc func textChanged(sender: UITextField?) {
//        guard let id = self.idLocation else {
//            return
//        }
//        row.value = id
//        row.validate()
//    }

    
    func updateUI(title: String, placeHolder: String) {
        self.lbTitle.text = title
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }

}

