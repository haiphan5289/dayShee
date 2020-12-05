//
//  ProductDetailCell.swift
//  Dayshee
//
//  Created by haiphan on 11/8/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit

class ProductDetailCell: UITableViewCell {

    let vImage: PDViewImage = PDViewImage.loadXib()
    let vDetail: PDDetail = PDDetail.loadXib()
    let vComment: PDDCommentView = PDDCommentView.loadXib()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .white
        self.addSubview(vImage)
        vImage.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
        }
        self.addSubview(vDetail)
        vDetail.snp.makeConstraints { (make) in
            make.top.equalTo(self.vImage.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(10).priority(.high)
        }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func addViewComment() {
        self.addSubview(vComment)
        vComment.snp.makeConstraints { (make) in
            make.top.equalTo(self.vDetail.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }
    }
}
