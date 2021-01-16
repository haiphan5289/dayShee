//
//  BannerCell.swift
//  Dayshee
//
//  Created by paxcreation on 11/4/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class BannerCell: UICollectionViewCell {

    var callBack: (() -> Void)?
    @IBOutlet weak var img: UIImageView!
    private let disposeBag = DisposeBag()
    @IBOutlet weak var imgRatio: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

}
struct MyConstraint {
  static func changeMultiplier(_ constraint: NSLayoutConstraint, multiplier: CGFloat) -> NSLayoutConstraint {
    let newConstraint = NSLayoutConstraint(
      item: constraint.firstItem,
      attribute: constraint.firstAttribute,
      relatedBy: constraint.relation,
      toItem: constraint.secondItem,
      attribute: constraint.secondAttribute,
      multiplier: multiplier,
      constant: constraint.constant)

    newConstraint.priority = constraint.priority

    NSLayoutConstraint.deactivate([constraint])
    NSLayoutConstraint.activate([newConstraint])

    return newConstraint
  }
}
