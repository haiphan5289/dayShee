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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//
    }

}
