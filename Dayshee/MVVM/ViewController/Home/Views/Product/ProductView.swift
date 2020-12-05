//
//  ProductView.swift
//  Dayshee
//
//  Created by paxcreation on 11/6/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import DZNEmptyDataSet

class ProductView: UIView, UpdateDisplayProtocol, DisplayStaticHeightProtocol {
    static var height: CGFloat { return 0 }
    static var bottom: CGFloat { return 0 }
    static var automaticHeight: Bool { return true }
    @IBOutlet weak var btViewAll: UIButton!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var hView: NSLayoutConstraint!
    var didSelectIndex: ((Int) -> Void)?
    var selectViewAll: (() -> Void)?
//    private var dataSource: BehaviorRelay<[Product]> = BehaviorRelay.init(value: [])
    @VariableReplay private var dataSource: [Product] = []
    private let heightCell = 160
    
    private let disposeBag = DisposeBag()
}
extension ProductView: Weakifiable {
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
extension ProductView {
    func setupDisplay(item: [Product]?) {
        guard let item = item else {
            return
        }
        self.dataSource = item
    }
    
    private func setupRX() {
        
        self.$dataSource.asObservable()
            .bind(to: collectionView.rx.items(cellIdentifier: ProductViewCell.identifier, cellType: ProductViewCell.self)) { row, data, cell in
                cell.lbPrice.text = data.maxPrice?.currency
                cell.lbPriceDiscount.text = data.minPrice?.currency
                cell.lbName.text = data.name ?? ""
                guard let textUrl = data.imageURL, let url = URL(string: textUrl) else {
                    return
                }
                cell.imgProduct.kf.setImage(with: url)
        }.disposed(by: disposeBag)
        
        self.btViewAll.rx.tap.bind { _ in
            self.selectViewAll?()
        }.disposed(by: disposeBag)
    }
    private func visualize() {
        
        let vLine: UIView = UIView(frame: .zero)
        vLine.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        self.addSubview(vLine)
        vLine.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.right.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        collectionView.delegate = self
        collectionView.register(ProductViewCell.nib, forCellWithReuseIdentifier: ProductViewCell.identifier)
    }
    func setupUI(title: String, hidenImage: Bool) {
        lbTitle.text = title
    }
    func updateHeightCell(table: UITableView, count: Int) {
        guard count > 0 else {
            self.hView.constant = 200
//            self.isHidden = false
            return
        }
//        self.isHidden = false
        var ratio = Int(count / 3)
        if count % 3 > 0 {
            ratio += 1
        }
        self.hView.constant = CGFloat((ratio * heightCell) + 65)
        table.beginUpdates()
        table.endUpdates()
    }
}
extension ProductView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (Int(self.bounds.width) - 20) / 3, height: heightCell)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = self.dataSource[indexPath.row].id ?? 0
        self.didSelectIndex?(id)
    }
}
extension ProductView: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "Chưa có sản phẩm"
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red,
                                   NSAttributedString.Key.font: UIFont.systemFont(ofSize: 19) ]
        let t = NSAttributedString(string: text, attributes: titleTextAttributes)
        return t
    }
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 0
    }
//    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
//        let text = "This allows you to share photos from your library and save photos to your camera roll."
//        let paragraph = NSMutableParagraphStyle()
//        paragraph.lineBreakMode = .byWordWrapping
//        paragraph.alignment = .center
//        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
//                                   NSAttributedString.Key.font: UIFont.systemFont(ofSize: 19),
//                                   NSAttributedString.Key.paragraphStyle: paragraph
//        ]
//        let t = NSAttributedString(string: text, attributes: titleTextAttributes)
//        return t
//    }
//    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControl.State) -> NSAttributedString! {
//        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
//                                   NSAttributedString.Key.font: UIFont.systemFont(ofSize: 19)]
//        let t = NSAttributedString(string: "Continue", attributes: titleTextAttributes)
//        return t
//    }
//    func buttonImage(forEmptyDataSet scrollView: UIScrollView!, for state: UIControl.State) -> UIImage! {
//        return UIImage(named: "ic_filter")
//    }
//    func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
//        return 50
//    }
//    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
//        return true
//    }
//    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
//        return true
//    }
//    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
//        print("kokoo")
//    }
}

