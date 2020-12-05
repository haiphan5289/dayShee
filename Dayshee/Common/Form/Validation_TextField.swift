//
//  ValidationTextFiled.swift
//  istream4u
//
//  Created by Dong Nguyen on 4/5/18.
//  Copyright © 2018 com.kantek.istream4u. All rights reserved.
//

import UIKit
import EasyTipView
import SnapKit

enum VALIDATION_TYPE : String {
    case ZIPCODE_LIMIT     = "^.{5,10}$",
    ZIPCODE           = "^([0-9]{5})(?:[-\\s]*([0-9]{4}))?$",
    PASSWORD_LIMIT    = "^.{8,}$",
    PASSWORD          = "[A-Za-z0-9]{6,20}",
    USER_NAME_LIMIT   = "^.{3,15}$",
    USER_NAME         = "[a-z0-9_]{3,15}",
    EMAIL             = "[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}",
    PHONE_US          = "((\\(\\d{3}\\) ?)|(\\d{3}-))?\\d{3}-\\d{4}",
    NUMBER            = "^\\d+$",
    NUMBER_COMMA      = "^\\d{1,3}([,]\\d{3})*$",
    ALPHABET          = "^[a-zA-Z]+$",
    ALPHA_NUMERIC     = "^[a-zA-Z0-9]+$",
    CREDIT_CARD_LIMIT = "^.{10,23}$",
    CVV_LIMIT         = "^.{3,4}$",
    REQUIRED          = "^(\\s|\\S)*(\\S)+(\\s|\\S)*$",
    ID          = "[A-Za-z0-9]{4,20}",
    NONE = ""
}

let kMsgRequired = "Please input value"
class Validation_TextField: UITextField {
    
    private let imgError = UIImageView()
    private var messageValidate = kMsgRequired
    private var tipView : EasyTipView?
    private var validateType : VALIDATION_TYPE = .REQUIRED
    
    private var isValidValue = false {
        didSet {
            imgError.isHidden = isValidValue
            rightViewMode = isValidValue == true ? .always : .never
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let frame = self.bounds
        imgError.frame = CGRect.init()
        addSubview(imgError)
        bringSubviewToFront(imgError)
        imgError.isUserInteractionEnabled = true
        imgError.image = UIImage.init(named: "imgError")
        imgError.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(didTapImage(_ : ))))
        imgError.isHidden = true
        imgError.snp.makeConstraints { (make) in
            make.width.height.equalTo(frame.size.height)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        self.addTarget(self, action: #selector(didChageValue(_ : )), for: .editingChanged)
    }
    
    func setValidate(type : VALIDATION_TYPE, message : String) {
        validateType = type
        messageValidate = message
        
    }
    
    @objc func didTapImage(_ sender : Any) {
        if tipView == nil {
            tipView = EasyTipView(text: messageValidate)
            tipView?.backgroundColor = UIColor.init(hex: "d72828")
            tipView?.show(animated: true, forView: self, withinSuperview: self.superview?.superview)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.tipView?.dismiss(withCompletion: {
                    self?.tipView = nil
                })
            }
        }
    }
    
    @objc func didChageValue(_ sender : Any) {
        validateValue()
    }
    
    func validateValue() {
        let value = self.text ?? ""
        isValidValue = value.range(of: validateType.rawValue, options: .regularExpression) != nil
    }
    
    func isValid() -> Bool {
        return isValidValue
    }
}


class Validation_TextView: UITextView {
    
    private let imgError = UIImageView()
    private var messageValidate = "This field is required"
    private var tipView : EasyTipView?
    private var validateType : VALIDATION_TYPE = .NONE
    
    private var isValidValue = false {
        didSet {
            imgError.isHidden = isValidValue
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let frame = self.bounds
        imgError.frame = CGRect.init(x: frame.width - 35, y: 0, width: 30, height: 30)
        addSubview(imgError)
        bringSubviewToFront(imgError)
        imgError.isUserInteractionEnabled = true
        imgError.image = UIImage.init(named: "imgError")
        imgError.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(didTapImage(_ : ))))
        imgError.isHidden = true
        
        //        self.addta
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        let width = self.bounds.size.width / 2
        imgError.snp.makeConstraints { (make) in
            
            make.centerX.equalToSuperview().offset(width - 5)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
        }
    }
    func setValidate(type : VALIDATION_TYPE, message : String) {
        validateType = type
        messageValidate = message
        
    }
    
    @objc func didTapImage(_ sender : Any) {
        if tipView == nil {
            tipView = EasyTipView(text: messageValidate)
            tipView?.backgroundColor = UIColor.init(hex: "d72828")
            tipView?.show(animated: true, forView: self, withinSuperview: self.superview?.superview)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.tipView?.dismiss(withCompletion: {
                    self?.tipView = nil
                })
            }
        }
    }
    
    @objc func didChageValue(_ sender : Any) {
        validateValue()
    }
    
    func validateValue() {
        if validateType == .NONE {
            isValidValue = true
        } else {
            let value = self.text ?? ""
            isValidValue = value.range(of: validateType.rawValue, options: .regularExpression) != nil
        }
    }
    
    func isValid() -> Bool {
        return isValidValue
    }
}
