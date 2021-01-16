//
//  UIButton+Extension.swift
//  Dayshee
//
//  Created by paxcreation on 1/8/21.
//  Copyright © 2021 ThanhPham. All rights reserved.
//

import UIKit

class HighlightedButton: UIButton {

    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? BUTTON_COLOR : COLOR_APP
        }
    }
}
