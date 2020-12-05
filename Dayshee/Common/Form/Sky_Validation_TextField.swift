//
//  ValidationTextFiled.swift
//  istream4u
//
//  Created by Dong Nguyen on 4/5/18.
//  Copyright © 2018 com.kantek.istream4u. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField


class Sky_Validation_TextField: SkyFloatingLabelTextField {
    
    private var messageValidate = "This field is required"
    private var validateType : VALIDATION_TYPE = .REQUIRED
    private var isValidValue = false {
        didSet {
            self.errorMessage = isValidValue ? "" : messageValidate
            self.lineColor = isValidValue ? UIColor.lightGray : UIColor.red
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addTarget(self, action: #selector(didChageValue(_ : )), for: .editingChanged)
    }
    
    func setValidate(type : VALIDATION_TYPE, message : String) {
        validateType = type
        messageValidate = message
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
