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

class RowCellRegisterDistrict: Eureka.Cell<Bool>, CellType, UITextFieldDelegate, UpdateDisplayProtocol {
    func setupDisplay(item: Bool?) {
        
    }

    private let stackView: UIStackView = UIStackView(frame: .zero)
    private var pickerView: UIPickerView = UIPickerView(frame: .zero)
    private var wardPickerView: UIPickerView = UIPickerView(frame: .zero)
    let lbDistrict: UILabel = UILabel(frame: .zero)
    let lbWard: UILabel = UILabel(frame: .zero)
    let tfSub: UITextField = UITextField(frame: .zero)
    let tfWard: UITextField = UITextField(frame: .zero)
    let img: UIImageView = UIImageView(frame: .zero)
    var listDistrict: BehaviorRelay<[District]> = BehaviorRelay.init(value: [])
    var districtID: PublishSubject<Int> = PublishSubject.init()
    var listWard: BehaviorRelay<[Ward]> = BehaviorRelay.init(value: [])
    var wardID: PublishSubject<Int?> = PublishSubject.init()
    var currentDistrict: District?
    var currentWard: Ward?
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
        self.tfSub.inputView = pickerView
        
        self.backgroundColor = .clear
        selectionStyle = .none
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(10)
            make.left.right.equalToSuperview().inset(55)
            make.top.equalToSuperview()
        }
        let vDistrict: UIView = UIView()
        vDistrict.addSubview(lbDistrict)
        lbDistrict.text = "Quân/huyện"
        lbDistrict.textAlignment = .left
        lbDistrict.font = UIFont(name: "Montserrat-Regular", size: 12.0)
        
        vDistrict.addSubview(lbDistrict)
        lbDistrict.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.left.right.equalToSuperview()
        }
        
        vDistrict.addSubview(tfSub)
        let colorDistrict = UIColor.black
        tfSub.placeholder = "Chọn"
        let placeholderDistrict = tfSub.placeholder ?? "" //There should be a placeholder set in storyboard or elsewhere string or pass empty
        tfSub.attributedPlaceholder = NSAttributedString(string: placeholderDistrict, attributes: [NSAttributedString.Key.foregroundColor : colorDistrict])
        tfSub.font = UIFont(name: "Montserrat-Regular", size: 12.0)
        tfSub.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: tfSub.frame.height))
        tfSub.rightViewMode = .always
        tfSub.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.lbDistrict.snp.bottom).inset(-10)
        }
        
        let imgDistrict: UIImageView = UIImageView(frame: .zero)
        imgDistrict.image = UIImage(named: "ic_chevron_right")
        tfSub.addSubview(imgDistrict)
        imgDistrict.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(5)
        }
        
        let vLine: UIView = UIView(frame: .zero)
        vLine.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 1)
        vDistrict.addSubview(vLine)
        vLine.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.tfSub.snp.bottom).inset(-5)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
        
        let vWard: UIView = UIView()
        vWard.addSubview(lbWard)
        lbWard.text = "Phường/Xã"
        lbWard.textAlignment = .left
        lbWard.font = UIFont(name: "Montserrat-Regular", size: 12.0)
        
        vWard.addSubview(lbWard)
        lbWard.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.left.right.equalToSuperview()
        }
        
        vWard.addSubview(tfWard)
        tfWard.placeholder = "Chọn"
        let colorWard = UIColor.black
        let placeholderWard = tfSub.placeholder ?? "" //There should be a placeholder set in storyboard or elsewhere string or pass empty
        tfWard.attributedPlaceholder = NSAttributedString(string: placeholderWard, attributes: [NSAttributedString.Key.foregroundColor : colorWard])
        tfWard.font = UIFont(name: "Montserrat-Regular", size: 12.0)
        tfWard.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: tfWard.frame.height))
        tfWard.rightViewMode = .always
        tfWard.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.lbWard.snp.bottom).inset(-10)
        }
        
        tfWard.inputView = wardPickerView
        
        let imgWard: UIImageView = UIImageView(frame: .zero)
        imgWard.image = UIImage(named: "ic_chevron_right")
        tfWard.addSubview(imgWard)
        imgWard.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(5)
        }
        
        let vLineWard: UIView = UIView(frame: .zero)
        vLineWard.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 1)
        vWard.addSubview(vLineWard)
        vLineWard.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.tfWard.snp.bottom).inset(-5)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
        
        stackView.addArrangedSubviews([vDistrict, vWard])
    }
    
    private func setupRX() {
        tfSub.delegate = self
        tfSub.addTarget(self, action: #selector(textChanged(sender:)), for: .valueChanged)
        tfSub.addTarget(self, action: #selector(textChanged(sender:)), for: .editingChanged)
        tfSub.addTarget(self, action: #selector(textChanged(sender:)), for: .editingDidEnd)
        
        tfWard.delegate = self
        tfWard.addTarget(self, action: #selector(textChanged(sender:)), for: .valueChanged)
        tfWard.addTarget(self, action: #selector(textChanged(sender:)), for: .editingChanged)
        tfWard.addTarget(self, action: #selector(textChanged(sender:)), for: .editingDidEnd)
        
        listDistrict.bind(to: pickerView.rx.itemTitles) { (row, element) in
            return element.district
        }.disposed(by: disposeBag)
        
        pickerView.rx.itemSelected
            .bind(onNext: { [weak self] (row, element) in
                guard let wSelf = self else {
                    return
                }
                wSelf.currentDistrict = wSelf.listDistrict.value[row]
                wSelf.districtID.onNext(wSelf.listDistrict.value[row].id ?? 0)
                wSelf.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        listWard.bind(to: wardPickerView.rx.itemTitles) { (row, element) in
            return element.ward
        }.disposed(by: disposeBag)
        
        wardPickerView.rx.itemSelected
            .bind(onNext: { [weak self] (row, element) in
                guard let wSelf = self else {
                    return
                }
                
                guard wSelf.listWard.value.count > 0 else {
                    return
                }
                wSelf.currentWard = wSelf.listWard.value[row]
                wSelf.wardID.onNext(wSelf.listWard.value[row].id ?? 0)
                wSelf.endEditing(true)
            })
            .disposed(by: disposeBag)

    }
    @objc func textChanged(sender: UITextField?) {
        guard let district = self.currentDistrict else {
            return
        }
        
        self.tfSub.text = district.district
        
        guard let ward = self.currentWard else {
            return
        }
        
        self.tfWard.text = ward.ward
        
        guard let isDistrict = self.tfSub.text?.isEmpty ,
              let isWard = self.tfWard.text?.isEmpty,
              !isDistrict && !isWard
              else {
            return
        }
        
        row.value = true
        row.validate()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
}
