//
//  RateCell.swift
//  Dayshee
//
//  Created by haiphan on 12/7/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxSwift

class RateCell: UICollectionViewCell {

    var remove: (() -> Void)?
    @IBOutlet weak var btRemove: UIButton!
    @IBOutlet weak var img: UIImageView!
    private let disposeBag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btRemove.rx.tap.bind { _ in
            self.remove?()
        }.disposed(by: disposeBag)
    }

}
