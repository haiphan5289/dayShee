//
//  ReferralCodeView.swift
//  Dayshee
//
//  Created by paxcreation on 11/26/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ReferralCodeView: UIView, UpdateDisplayProtocol, DisplayStaticHeightProtocol{
    static var height: CGFloat { return 0 }
    static var bottom: CGFloat { return 0 }
    static var automaticHeight: Bool { return true }
    var upateHeightNoteView: (() -> Void)?
    var textNote:((String) -> Void)?
    
    @IBOutlet weak var tvReferralCode: UITextView!
    @IBOutlet weak var heightReferralCode: NSLayoutConstraint!
    
    @Replay(queue: MainScheduler.asyncInstance) private var heightNote: CGFloat
    
    private let disposeBag = DisposeBag()
}
extension ReferralCodeView: Weakifiable {
    override func awakeFromNib() {
        super.awakeFromNib()
        visualize()
        setupRX()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    override func removeFromSuperview() {
        superview?.removeFromSuperview()
    }
    
}
extension ReferralCodeView {
    func setupDisplay(item: [HomeDetailModel]?) {
        guard let item = item else {
            return
        }
    }
    
    private func setupRX() {
        tvReferralCode.textColor = #colorLiteral(red: 0.3882352941, green: 0.4470588235, blue: 0.5019607843, alpha: 1)
        tvReferralCode.rx.didBeginEditing.bind(onNext: weakify { (wSelf) in
            self.tvReferralCode.text = nil
            self.tvReferralCode.textColor = #colorLiteral(red: 0.06666666667, green: 0.06666666667, blue: 0.06666666667, alpha: 1)
        }).disposed(by: disposeBag)
        
        self.tvReferralCode.rx.text.orEmpty.skip(1).bind(onNext: weakify({ (text, wSelf) in
            guard text != "" else {
                wSelf.heightNote = 40
                return
            }
            let size = text.getTextSizeNoteView(fontSize: 14, width: wSelf.tvReferralCode.bounds.width,
                                                height: wSelf.tvReferralCode.bounds.height)
            wSelf.heightNote = size.height + 20
            wSelf.textNote?(text)
        })).disposed(by: disposeBag)
        
        self.$heightNote
            .distinctUntilChanged()
            .asObservable()
            .bind(onNext: weakify({ (height, wSelf) in
                wSelf.heightReferralCode.constant = height
                wSelf.upateHeightNoteView?()
        })).disposed(by: disposeBag)
    }
    private func visualize() {
        self.tvReferralCode.text = "Nhập mã giới thiệu"
        self.tvReferralCode.textColor = #colorLiteral(red: 0.3882352941, green: 0.4470588235, blue: 0.5019607843, alpha: 1)
    }
    func setupFromOrderDetail(text: String?) {
        self.tvReferralCode.isUserInteractionEnabled = false
        guard let text = text,  !text.isEmpty, text != "" else {
            self.tvReferralCode.text = "Không có ghi chú"
            self.tvReferralCode.textColor = #colorLiteral(red: 0.3882352941, green: 0.4470588235, blue: 0.5019607843, alpha: 1)
            self.heightNote = 40
            return
        }
        self.tvReferralCode.text = text
        self.tvReferralCode.textColor = .black
        let size = text.getTextSizeNoteView(fontSize: 14, width: self.tvReferralCode.bounds.width,
                                            height: self.tvReferralCode.bounds.height)
        self.heightNote = size.height + 20
    }
   
}
