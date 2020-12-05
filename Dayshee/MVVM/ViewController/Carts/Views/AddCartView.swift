//
//  AddCartView.swift
//  Dayshee
//
//  Created by paxcreation on 11/6/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import Kingfisher

class AddCartView: UIView, UpdateDisplayProtocol, DisplayStaticHeightProtocol {
    
    static var height: CGFloat { return 0 }
    static var bottom: CGFloat { return 0 }
    static var automaticHeight: Bool { return true }
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var btClose: UIButton!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbAmount: UILabel!
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
extension AddCartView: Weakifiable {
    override func awakeFromNib() {
        super.awakeFromNib()
        setupRX()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        visualize()
    }
    override func removeFromSuperview() {
        superview?.removeFromSuperview()
    }
    
}
extension AddCartView {
    func setupDisplay(item: Product?) {
        guard let item = item else {
            return
        }
        self.lbName.text = item.name ?? ""
        self.lbPrice.text = "\(item.minPrice ?? 0)"
        self.lbAmount.text = "\(01)"
        guard  let textUrl = item.imageURL, let url = URL(string: textUrl) else {
            return
        }
        img.kf.setImage(with: url)
    }
    
    private func setupRX() {
       
    }
    private func visualize() {
    }
    func setupUI(title: String, hidenImage: Bool) {
    }
}

