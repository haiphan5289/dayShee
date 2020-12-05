//
//  ListDiscountCell.swift
//  Dayshee
//
//  Created by paxcreation on 11/17/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import ReadMoreTextView

class ListDiscountCell: UITableViewCell {

    var eventReadMore:((Bool) -> Void)?
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var tvContent: ReadMoreTextView!
    @IBOutlet weak var hTvContent: NSLayoutConstraint!
    @IBOutlet weak var lbTimeApply: UILabel!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        var myMutableString = NSMutableAttributedString()

        let text = "....Xem thêm"
        myMutableString = NSMutableAttributedString(string: text)

        myMutableString.setAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)
                                       , NSAttributedString.Key.foregroundColor : UIColor.blue],
                                      range: NSRange(location: 0, length: text.count))
        tvContent.attributedReadMoreText = myMutableString
        
        
        let textUnless = "....thu gọn"
        var myMutableStringLess = NSMutableAttributedString()
        myMutableStringLess = NSMutableAttributedString(string: textUnless)

        myMutableStringLess.setAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)
                                       , NSAttributedString.Key.foregroundColor : UIColor.blue],
                                      range: NSRange(location: 0, length: textUnless.count))
        tvContent.attributedReadLessText = myMutableStringLess
        tvContent.eventReadMore = { isSeeMore in
            self.eventReadMore?(isSeeMore)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setuoSke(count: Int) {
        let views = [lbTitle, tvContent, lbTimeApply, img]
        guard count > 0 else {
            views.forEach { (v) in
                v?.isSkeletonable = true
                v?.showGradientSkeleton()
            }
            return
        }
        views.forEach { (v) in
            v?.hideSkeleton()
        }
    }
    
}
