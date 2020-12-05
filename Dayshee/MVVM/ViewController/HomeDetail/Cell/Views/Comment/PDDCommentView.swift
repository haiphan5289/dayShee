//
//  PDDCommentView.swift
//  Dayshee
//
//  Created by haiphan on 11/8/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Cosmos

class PDDCommentView: UIView {
    
    var updateHeight: (() -> Void)?
    var moveToListRating:(([ProductRating]) -> Void)?
    var moveToRate: ((Int) -> Void)?
    @IBOutlet weak var vContent: UIView!
    private let tableView: UITableView = UITableView(frame: .zero, style: .plain)
    let cosmosView: CosmosView = CosmosView(frame: .zero, settings: .default)
    
    @VariableReplay var hegihtCell: CGFloat = 0
    @VariableReplay private var dataSource: [ProductRating] = []
    private var listFAQ: [ProductRating] = []
    private var totalRating: Double = 0
    private let disposeBag = DisposeBag()
}
extension PDDCommentView: Weakifiable {
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
extension PDDCommentView {
    private func visualize() {
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.sectionHeaderHeight = 0.1
        self.vContent.addSubview(self.tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
            make.height.equalTo(200)
        }
        tableView.delegate = self
        tableView.register(PDDCommentCell.nib, forCellReuseIdentifier: PDDCommentCell.identifier)
        
    }
    private func setupRX() {
        self.$dataSource.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: PDDCommentCell.identifier, cellType: PDDCommentCell.self)) {(row, element, cell) in
                cell.backgroundColor = (row % 2 == 0) ? .orange : .brown
                cell.lbContent.text = element.comment
                cell.viewRating.rating = element.rating ?? 0
                cell.lbName.text = element.user?.name
                self.hegihtCell += element.comment?.getTextSize(fontSize: 17, width: self.tableView.bounds.width).height ?? 0
                guard let date = element.createdAt?.toDate()?.date else {
                    return
                }
                let dateNow = NSDate().timeIntervalSince1970
                let t = dateNow - date.timeIntervalSince1970
                cell.lbTime.text = (t > 1) ? date.string(from: "yyyy-MM-dd") : "Cách đây 1 ngày"
            }.disposed(by: disposeBag)
        
        self.$hegihtCell.asObservable().bind(onNext: weakify({ (height, wSelf) in
            guard height > 0 else {
                wSelf.updateHeight?()
                return
            }
            let heightHeaderFooter: CGFloat = 30
            let heightLbNameViewCosmos: CGFloat = 33
            let spacingOutLetCell: CGFloat = 20
//            wSelf.hTableView.constant = height + (heightHeaderFooter * 2) + (heightLbNameViewCosmos * 2) + (spacingOutLetCell * 2)
            wSelf.tableView.snp.updateConstraints { (make) in
                make.height.equalTo(height + (heightHeaderFooter * 2) + (heightLbNameViewCosmos * 2) + (spacingOutLetCell * 2))
            }
            wSelf.updateHeight?()
        })).disposed(by: disposeBag)
        
    }
    func setupDisplay(item: HomeDetailModel?) {
        guard let item = item, let list = item.productRatings else {
            return
        }
        self.listFAQ = list
        if list.count > 2 {
            for i in 0...1 {
                self.dataSource.append(list[i])
            }
        } else {
            self.dataSource = list
        }
        
        list.forEach { (v) in
            self.totalRating += (v.rating ?? 0)
        }
        cosmosView.rating = (list.count > 0) ? self.totalRating / Double(list.count) : 5
        
        
    }
}
extension PDDCommentView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v: UIView = UIView(frame: .zero)
        let lbComment: UILabel = UILabel(frame: .zero)
        lbComment.text = "Nhận xét (\(self.listFAQ.count))"
        lbComment.font = UIFont.systemFont(ofSize: 15)
        v.addSubview(lbComment)
        lbComment.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
        }


        cosmosView.settings.totalStars = 5
        cosmosView.settings.updateOnTouch = false
        cosmosView.settings.fillMode = .half
        cosmosView.settings.starSize = 15
        cosmosView.settings.starMargin = 3
        cosmosView.settings.filledColor = UIColor.black
        cosmosView.settings.emptyBorderColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
        cosmosView.settings.filledBorderColor = UIColor.black
        v.addSubview(cosmosView)
        cosmosView.snp.makeConstraints { (make) in
            make.left.equalTo(lbComment.snp.right).inset(-5)
            make.centerY.equalTo(lbComment)
        }

        let btSeeAll: UIButton = UIButton(frame: .zero)
        btSeeAll.setTitle("Xem tất cả     ", for: .normal)
        btSeeAll.setTitleColor(.black, for: .normal)
        btSeeAll.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        let img: UIImage = UIImage(named: "ic_chevron_black") ?? UIImage()
        btSeeAll.imageView?.snp.makeConstraints({ (make) in
            make.centerY.right.equalToSuperview()
        })
        btSeeAll.setImage(img, for: .normal)
        v.addSubview(btSeeAll)
        btSeeAll.snp.makeConstraints { (make) in
            make.right.centerY.equalToSuperview()
        }

        btSeeAll.rx.tap.bind { _ in
            self.moveToListRating?(self.listFAQ)
        }.disposed(by: disposeBag)
        
        return v
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v: UIView = UIView(frame: .zero)
        
        let btSendComment: UIButton = UIButton(frame: .zero)
        let underLineButton: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 13),
            .foregroundColor: UIColor.black,
            .underlineStyle: NSUnderlineStyle.single.rawValue]
        let attributeString = NSMutableAttributedString(string: "Gửi nhận xét",
                                                             attributes: underLineButton)
        btSendComment.setAttributedTitle(attributeString, for: .normal)
        v.addSubview(btSendComment)
        btSendComment.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        btSendComment.rx.tap.bind { _ in
            let first = self.listFAQ.first
            self.moveToRate?(first?.productID ?? 0)
        }.disposed(by: disposeBag)
        
        return v
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
}

