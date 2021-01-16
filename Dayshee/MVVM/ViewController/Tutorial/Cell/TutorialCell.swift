//
//  TutorialCell.swift
//  Dayshee
//
//  Created by haiphan on 12/28/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TutorialCell: UICollectionViewCell {

    @IBOutlet weak var vGift: UIView!
    @IBOutlet weak var vMarketing: UIView!
    @IBOutlet weak var vManahe: UIView!
    @IBOutlet weak var lbTitle: UILabel!
    let vImg: UIView = UIView()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.clipsToBounds = true
        self.layer.cornerRadius = 5
        
        vImg.clipsToBounds = true
        self.addSubview(vImg)
        vImg.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.lbTitle.snp.top).inset(-50)
            make.top.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(vImg.snp.height).multipliedBy(1)
        }
    }
    func addImageIcon(row: Int, height: CGFloat) {
        let imgShow: UIImageView = UIImageView()
        switch row {
        case 0:
            imgShow.image = UIImage(named: "ic_tutorial_marketing")
        case 1:
            imgShow.image = UIImage(named: "ic_tutorial_manage")
        case 2:
            imgShow.image = UIImage(named: "ic_tutorial_gift")
        default:
            break
        }
        imgShow.clipsToBounds = true
        imgShow.sizeToFit()
        vImg.addSubview(imgShow)
        imgShow.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.width.equalTo(height)
        }
    }
    

}
