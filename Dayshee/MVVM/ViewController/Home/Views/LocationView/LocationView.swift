//
//  LocationView.swift
//  Dayshee
//
//  Created by paxcreation on 1/6/21.
//  Copyright © 2021 ThanhPham. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class LocationView: UIView {
    var actionStartOrder: ((Location) -> Void)?
    @IBOutlet weak var tfLocation: UITextField!
    @IBOutlet weak var btLocation: UIButton!
    @IBOutlet weak var btStartOrder: UIButton!
    @IBOutlet weak var btClose: UIButton!
    private var pickerView: UIPickerView = UIPickerView(frame: .zero)
    private var currentLocation: Location?
    @VariableReplay var listLocation: [Location] = []
    private let disposeBag = DisposeBag()
}
extension LocationView: Weakifiable {
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
extension LocationView {
    private func visualize() {
        self.tfLocation.inputView = pickerView
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let bOK: UIButton = UIButton(type: .custom)
        bOK.setTitle("Xong", for: .normal)
        bOK.setTitleColor(.blue, for: .normal)
        bOK.titleLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 15)
        let doneButton = UIBarButtonItem(customView: bOK)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([doneButton,spaceButton], animated: false)
        tfLocation.inputAccessoryView = toolbar
        tfLocation.inputView = pickerView
        
        bOK.rx.tap.bind { [weak self] _ in
            guard let wSelf = self else {
                return
            }
//            wSelf.tfSub.text = wSelf.datePicker.date.string(from: "yyyy-mm-dd")
            wSelf.endEditing(true)
        }.disposed(by: disposeBag)
    }
    private func setupRX() {
        self.btLocation.rx.tap.bind { _ in
            self.tfLocation.becomeFirstResponder()
        }.disposed(by: disposeBag)
        
        self.$listLocation.asObservable().bind(to: pickerView.rx.itemTitles) { (row, element) in
            return element.province
        }.disposed(by: disposeBag)
        
        self.$listLocation.asObservable().bind(onNext: weakify({ (l, wSelf) in
            guard let f = l.first else {
                return
            }
            wSelf.tfLocation.text = f.province
            wSelf.currentLocation = f
        })).disposed(by: disposeBag)
        
        pickerView.rx.itemSelected
            .bind(onNext: { [weak self] (row, element) in
                guard let wSelf = self else {
                    return
                }
                let item = wSelf.listLocation[row]
                wSelf.currentLocation = item
                wSelf.tfLocation.text = item.province
                wSelf.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        self.btStartOrder.rx.tap.bind { [weak self] _ in
            guard let wSelf = self, let item = wSelf.currentLocation else {
                return
            }
            wSelf.actionStartOrder?(item)
        }.disposed(by: disposeBag)
        
    }
}
