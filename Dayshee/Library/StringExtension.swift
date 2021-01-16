//
//  StringExtension.swift
//  Dayshee
//
//  Created by paxcreation on 11/2/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit

extension String {
    var isUpdateContain: Bool {
        let upperCase = CharacterSet.uppercaseLetters
        for i in self.unicodeScalars {
            if upperCase.contains(i) {
                return true
            }
        }
        return false
    }
//    var isNumeric: Bool {
//            guard self.count > 0 else { return false }
//            let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
//            return Set(self).isSubset(of: nums)
//    }
    var isHaveNumber: Bool {
        let decimalCharacters = CharacterSet.decimalDigits
        let decimalRange = self.rangeOfCharacter(from: decimalCharacters)
        if decimalRange != nil {
            return true
        }
        return false
    }
    func getTextSize(fontSize: CGFloat, width: CGFloat) -> CGRect {
        let size = CGSize(width: width, height: 50)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: self).boundingRect(with: size, options: options,
                                                   attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: fontSize)],
                                                   context: nil)
    }
    func getTextSizeNoteView(fontSize: CGFloat, width: CGFloat, height: CGFloat) -> CGRect {
        let size = CGSize(width: width, height: height)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: self).boundingRect(with: size, options: options,
                                                   attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: fontSize)],
                                                   context: nil)
    }
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
//    func toDate(from format: String) -> Date? {
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
//        dateFormatter.dateFormat = "\(format)"
//        let date = dateFormatter.date(from:self)
//        return date
//    }
    func toCovertDate(format: String) -> Date? {
        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
//        dateFormatter.dateFormat = format
        dateFormatter.dateFormat = format
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.locale = Locale.current
        let date = dateFormatter.date(from:"2020-01-10")
        return date
    }
}
extension UIImageView {
    func applyshadowWithCorner(containerView : UIView, cornerRadious : CGFloat){
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = UIColor.white.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = 10
        containerView.layer.cornerRadius = cornerRadious
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: cornerRadious).cgPath
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadious
    }

}
