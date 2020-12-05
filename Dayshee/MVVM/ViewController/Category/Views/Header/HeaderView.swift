//
//  HeaderView.swift
//  Dayshee
//
//  Created by haiphan on 11/8/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit

class HeaderView: UICollectionReusableView {
    var viewHotProduct: CategoryView = CategoryView.loadXib()
    func visualize(list: [Product]?) {
        guard let items = list else {
            return
        }
        self.addSubview(self.viewHotProduct)
        self.viewHotProduct.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.viewHotProduct.setupDisplay(item: items)
    }
}
