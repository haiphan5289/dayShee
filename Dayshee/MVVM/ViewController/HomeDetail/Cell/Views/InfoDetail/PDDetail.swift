//
//  PDDetail.swift
//  Dayshee
//
//  Created by haiphan on 11/8/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

enum TypeProductDetail: Int {
    case detail
    case description
}

class PDDetail: UIView {
    
    var updateCell: (() -> Void)?
    var moveToQA: (() -> Void)?
    var moveToListFAQ: (([ProductFAQ]) -> Void)?
    @IBOutlet weak var btDetail: UIButton!
    @IBOutlet weak var btDescription: UIButton!
    @IBOutlet weak var vLine: UIView!
    @IBOutlet weak var btViewAll: UIButton!
    @IBOutlet weak var btQA: UIButton!
    @IBOutlet weak var tvDescription: UITextView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var tvBottom: NSLayoutConstraint!
    @IBOutlet weak var hTVBottom: NSLayoutConstraint!
    @IBOutlet weak var stackViewBottom: NSLayoutConstraint!
    @IBOutlet weak var lbCategory: UILabel!
    @IBOutlet weak var lbOrigin: UILabel!
    @IBOutlet weak var lbTradeMark: UILabel!
    @IBOutlet weak var lbSKU: UILabel!
    @IBOutlet weak var lbManual: UILabel!
    @IBOutlet weak var lbFAQ: UILabel!
    @IBOutlet weak var lbQuestion: UILabel!
    @IBOutlet weak var lbAnswer: UILabel!
    @IBOutlet weak var vQuestion: UIView!
    @IBOutlet weak var vLineQuestion: UIView!
    @IBOutlet var imgQ: [UIImageView]!
    private var didSetup: PublishSubject<Void> = PublishSubject.init()
    private var listFAQ: [ProductFAQ] = []
    private let disposeBag = DisposeBag()
}
extension PDDetail: Weakifiable {
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
extension PDDetail {
    private func visualize() {
        
    }
    private func setupRX() {
        let detail = btDetail.rx.tap.map { TypeProductDetail.detail }
        let description = btDescription.rx.tap.map { TypeProductDetail.description }
        
        Observable.merge(detail, description)
            .asObservable()
            .bind(onNext: weakify({ (type, wSelf) in
                UIView.animate(withDuration: 0.3) {
                    wSelf.vLine.transform = CGAffineTransform(translationX: CGFloat(type.rawValue) * ((self.bounds.width - 40) / 2), y: 0)
                    self.stackView.isHidden = (type == .detail) ? false : true
                    self.tvDescription.isHidden = (type == .description) ? false : true
                    guard type == .detail else {
                        self.stackViewBottom.priority = .defaultLow
                        self.tvBottom.priority = .required
                        self.btDescription.titleLabel?.font = UIFont(name: FONT_MEDIUM, size: 14)!
                        self.btDetail.titleLabel?.font = UIFont(name: FONT_REGULAR, size: 14)!
                        self.btDescription.setTitleColor(.black, for: .normal)
                        self.btDetail.setTitleColor(.darkGray, for: .normal)
                        return
                    }
                    self.tvBottom.priority = .defaultLow
                    self.stackViewBottom.priority = .required
                 
                    self.btDetail.titleLabel?.font = UIFont(name: FONT_MEDIUM, size: 14)!
                    self.btDescription.titleLabel?.font = UIFont(name: FONT_REGULAR, size: 14)!
                    self.btDetail.setTitleColor(.black, for: .normal)
                    self.btDescription.setTitleColor(.darkGray, for: .normal)


                }
                self.layoutIfNeeded()
                self.updateCell?()
            })).disposed(by: disposeBag)
        
        self.btQA.rx.tap.bind { _ in
            self.moveToQA?()
        }.disposed(by: disposeBag)
        
        //warning update layout after 500 milliseconds
        self.didSetup.asObserver()
            .delay(.milliseconds(500), scheduler: MainScheduler.asyncInstance)
            .bind { _ in
                self.layoutIfNeeded()
                self.updateCell?()
            }.disposed(by: disposeBag)
        
        self.btViewAll.rx.tap.bind { _ in
            self.moveToListFAQ?(self.listFAQ)
        }.disposed(by: disposeBag)
        
    }
    func setupDisplay(item: HomeDetailModel?) {
        guard let item = item else {
            return
        }
        self.lbSKU.text = item.sku
        self.lbOrigin.text = item.origin?.origin
        self.lbCategory.text = item.category?.category
        self.lbTradeMark.text = item.trademark?.trademark
        self.hTVBottom.constant = self.tvDescription.text.getTextSize(fontSize: self.tvDescription.bounds.width, width: 13).height + 30
        
        if let att = item.dataDescription?.htmlToAttributedString  {
            let count = att.string.count
            let att1 = NSMutableAttributedString(attributedString: att)
            att1.addAttributes([NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 13.0) as Any ], range: NSMakeRange(0, count))
            tvDescription.attributedText = att1
        } else {
            self.hTVBottom.constant = 30
        }
        
        if let att = item.manuals?.htmlToAttributedString {
            let count = att.string.count
            let att1 = NSMutableAttributedString(attributedString: att)
            att1.addAttributes([NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 13.0) as Any ], range: NSMakeRange(0, count))
            lbManual.attributedText = att1
        }
        self.lbFAQ.text = "Hỏi đáp (\(item.productFaqs?.count ?? 0))"
        
        guard let listFAQ = item.productFaqs, listFAQ.count > 0 else {
            self.lbQuestion.text = ""
            self.lbAnswer.text = ""
            self.imgQ.forEach { (u) in
                u.isHidden = true
            }
            didSetup.onNext(())
            return
        }
        if let firstFAQ = item.productFaqs?.first {
            self.lbQuestion.text = firstFAQ.question
            self.lbAnswer.text = firstFAQ.answer
            self.imgQ.forEach { (u) in
                u.isHidden = false
            }
        }
        self.listFAQ = listFAQ
        didSetup.onNext(())
    }
}

