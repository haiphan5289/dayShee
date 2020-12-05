//
//  NoteView.swift
//  Dayshee
//
//  Created by paxcreation on 11/20/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class NoteView: UIView, UpdateDisplayProtocol, DisplayStaticHeightProtocol {
    static var height: CGFloat { return 0 }
    static var bottom: CGFloat { return 0 }
    static var automaticHeight: Bool { return true }
    var upateHeightNoteView: (() -> Void)?
    var textNote:((String) -> Void)?
    @IBOutlet weak var tvNote: UITextView!
    @IBOutlet weak var heightNoteView: NSLayoutConstraint!
    @Replay(queue: MainScheduler.asyncInstance) private var heightNote: CGFloat
    
    private let disposeBag = DisposeBag()
}
extension NoteView: Weakifiable {
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
extension NoteView {
    func setupDisplay(item: [HomeDetailModel]?) {
        guard let item = item else {
            return
        }
    }
    
    private func setupRX() {
        tvNote.textColor = #colorLiteral(red: 0.3882352941, green: 0.4470588235, blue: 0.5019607843, alpha: 1)
        tvNote.rx.didBeginEditing.bind(onNext: weakify { (wSelf) in
            self.tvNote.text = nil
            self.tvNote.textColor = #colorLiteral(red: 0.06666666667, green: 0.06666666667, blue: 0.06666666667, alpha: 1)
        }).disposed(by: disposeBag)
        
        self.tvNote.rx.text.orEmpty.skip(1).bind(onNext: weakify({ (text, wSelf) in
            guard text != "" else {
                wSelf.heightNote = 40
                return
            }
            let size = text.getTextSizeNoteView(fontSize: 14, width: wSelf.tvNote.bounds.width, height: wSelf.tvNote.bounds.height)
            wSelf.heightNote = size.height + 20
            wSelf.textNote?(text)
        })).disposed(by: disposeBag)
        
        self.$heightNote
            .distinctUntilChanged()
            .asObservable()
            .bind(onNext: weakify({ (height, wSelf) in
                wSelf.heightNoteView.constant = height
                wSelf.upateHeightNoteView?()
        })).disposed(by: disposeBag)
    }
    private func visualize() {
        self.tvNote.text = "Nhập ghi chú"
        self.tvNote.textColor = #colorLiteral(red: 0.3882352941, green: 0.4470588235, blue: 0.5019607843, alpha: 1)
    }
    func setupFromOrderDetail(text: String?) {
        self.tvNote.isUserInteractionEnabled = false
        guard let text = text,  !text.isEmpty, text != "" else {
            self.tvNote.text = "Không có ghi chú"
            self.tvNote.textColor = #colorLiteral(red: 0.3882352941, green: 0.4470588235, blue: 0.5019607843, alpha: 1)
            self.heightNote = 40
            return
        }
        self.tvNote.text = text
        self.tvNote.textColor = .black
        let size = text.getTextSizeNoteView(fontSize: 14, width: self.tvNote.bounds.width, height: self.tvNote.bounds.height)
        self.heightNote = size.height + 20
    }
   
}



