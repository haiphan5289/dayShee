//
//  NSObject+Extensions.swift
//  HelloSpa
//
//  Created by Dong Nguyen on 8/18/18.
//  Copyright © 2018 Dong Nguyen. All rights reserved.
//

import Foundation

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
extension Int {
    
    func formatnumber() -> String {
        let formater = NumberFormatter()
        formater.groupingSeparator = ","
        formater.numberStyle = .decimal
        return formater.string(from: NSNumber(value: self)) ?? ""
    }
    
    func formatnumberUSA() -> String {
        let formater = NumberFormatter()
        formater.groupingSeparator = ","
        formater.groupingSize = 3
        formater.usesGroupingSeparator = true
        formater.decimalSeparator = "."
        formater.numberStyle = .decimal
        formater.maximumFractionDigits = 2
        formater.numberStyle = .currency
        formater.currencyCode = "USD"
        formater.currencySymbol = "$"
        return formater.string(from: NSNumber(value: self)) ?? ""
    }
    
    func formatnumberVND() -> String {
        let formater = NumberFormatter()
        formater.groupingSeparator = ","
        formater.numberStyle = .decimal
        return "$\(formater.string(from: NSNumber(value: self.convert1000(self))) ?? "")"
    }
    
    func convert1000(_ price: Int) -> Int {
        let price = Int(self/1000)
        let price_ = Double(price)
        return Int(1000 * price_)
    }
}

extension Double {
    func formatnumber() -> String {
        let formater = NumberFormatter()
        formater.groupingSeparator = ","
        formater.numberStyle = .decimal
        return formater.string(from: NSNumber(value: self)) ?? ""
    }
    func formatnumberUSA() -> String {
        let formater = NumberFormatter()
        formater.groupingSeparator = ","
        formater.groupingSize = 3
        formater.usesGroupingSeparator = true
        formater.decimalSeparator = "."
        formater.numberStyle = .decimal
        formater.maximumFractionDigits = 2
        formater.numberStyle = .currency
        formater.currencyCode = "USD"
        formater.currencySymbol = "$"
        return formater.string(from: NSNumber(value: self)) ?? ""
    }
    
    func formatnumberVND() -> String {
        let formater = NumberFormatter()
        formater.groupingSeparator = ","
        formater.numberStyle = .decimal
        return "$\(formater.string(from: NSNumber(value: self.convert1000(self))) ?? "")"
    }
    func convert1000(_ price: Double) -> Double {
        let price = Int(self/1000)
        let price_ = Double(price)
        return 1000 * price_
    }
}
