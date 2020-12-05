//
//  NumberExtension.swift
//  Dayshee
//
//  Created by paxcreation on 11/5/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit

extension NSNumber {
    static let formatCurrency = format()
    
    private static func format() -> NumberFormatter {
        let format = NumberFormatter()
        format.locale = Locale(identifier: "vi_VN")
        format.numberStyle = .currency
        format.currencyGroupingSeparator = ","
        format.minimumFractionDigits = 0
        format.maximumFractionDigits = 0
        format.positiveFormat = "#,###\u{00a4}"
        return format
    }
    
    func money() -> String? {
       return NSNumber.formatCurrency.string(from: self)
    }
}

extension Numeric {
    var currency: String {
        return (self as? NSNumber)?.money() ?? ""//.currency(withISO3: "VND", placeSymbolFront: false) ?? ""
    }
}
