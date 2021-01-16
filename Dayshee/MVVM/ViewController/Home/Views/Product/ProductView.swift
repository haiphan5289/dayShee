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
    @IBOutlet weak var vTitle: UIView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHot: UICollectionView!
    //    @IBOutlet weak var hView: NSLayoutConstraint!
    @IBOutlet weak var topCollection: NSLayoutConstraint!
    var didSelectIndex: ((Int) -> Void)?
    var selectViewAll: (() -> Void)?
    var hasLoadData: Bool = false
    @VariableReplay private var dataSource: [Product] = []
    @VariableReplay private var dataSourceHot: [Product] = []
    private var currentIdx: Int = 0
    private var disposeScroll: Disposable?
    private let heightCell = 245
    
    private let disposeBag = DisposeBag()
}
extension ProductView: Weakifiable {
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
        self.clearAction()
    }
    
}
extension ProductView {
    func setupDisplay(item: [Product]?) {
        guard let item = item else {
            self.dataSource = []
            return
        }
        self.dataSource = item
    }
    
    private func setupRX() {
        self.autoScroll()
        
        self.$dataSource.asObservable()
            .bind(to: collectionView.rx.items(cellIdentifier: ProductViewCell.identifier, cellType: ProductViewCell.self)) { row, data, cell in
                cell.lbPrice.text = data.maxPrice?.currency
                cell.lbPriceDiscount.text = data.minPrice?.currency
                cell.lbName.text = data.name ?? ""
                self.hasLoadData = true
                guard let textUrl = data.imageURL, let url = URL(string: textUrl) else {
                    return
                }
                cell.imgProduct.kf.setImage(with: url)
        }.disposed(by: disposeBag)
        
        self.btViewAll.rx.tap.bind { _ in
            self.selectViewAll?()
        }.disposed(by: disposeBag)
        
        self.$dataSourceHot.asObservable()
            .bind(to: collectionViewHot.rx.items(cellIdentifier: HotProductCell.identifier, cellType: HotProductCell.self)) { row, data, cell in
                guard let textUrl = data.image16_9_URL, let url = URL(string: textUrl) else {
                    return
                }
                cell.img.kf.setImage(with: url)
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
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.register(ProductViewCell.nib, forCellWithReuseIdentifier: ProductViewCell.identifier)
        
    
        collectionViewHot.delegate = self
        collectionViewHot.register(HotProductCell.nib, forCellWithReuseIdentifier: HotProductCell.identifier)

    }
    func setupUI(title: String, hidenImage: Bool, hotProducts: [Product]) {
        lbTitle.text = "Sản phẩm \(title)"
        self.dataSourceHot = hotProducts
    }
    func updateHeightCell(table: UITableView, count: Int, item: ProductHomeModel) {
        guard count > 0 else {
            self.topCollection.constant = 5
            return
        }
        var ratio = Int(count / 3)
        if count % 3 > 0 {
            ratio += 1
        }
        table.beginUpdates()
        table.endUpdates()
    }
    private func clearAction() {
        disposeScroll?.dispose()
    }
    private func autoScroll() {
        disposeScroll?.dispose()
        
        disposeScroll = Observable<Int>.interval(.seconds(5), scheduler: MainScheduler.asyncInstance)
            .bind(onNext: weakify({ (_, wSelf) in
                guard wSelf.dataSourceHot.count > 0 else {
                    return
                }
                var next = wSelf.currentIdx + 1
                let count = wSelf.dataSourceHot.count
                next = next <= count - 1 ? next : 0
                wSelf.currentIdx = next
                wSelf.collectionViewHot.scrollToItem(at: IndexPath(item: next, section: 0), at: .centeredHorizontally, animated: true)
            }))
    }
}
extension ProductView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionViewHot {
            return self.collectionViewHot.bounds.size
        }
        let spacingCell = 20
        return CGSize(width: (Int(self.collectionView.bounds.width) - spacingCell) / 2, height: heightCell)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.collectionViewHot {
            return 0
        }
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.collectionViewHot {
            return 0
        }
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionViewHot {
            let id = self.dataSourceHot[indexPath.row].id ?? 0
            self.didSelectIndex?(id)
            return
        }
        let id = self.dataSource[indexPath.row].id ?? 0
        self.didSelectIndex?(id)
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        disposeScroll?.dispose()
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.autoScroll()
    }
}
//extension ProductView: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
//    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
//        let text = "Chưa có sản phẩm"
//        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red,
//                                   NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 19.0) ]
//        let t = NSAttributedString(string: text, attributes: titleTextAttributes as [NSAttributedString.Key : Any])
//        return t
//    }
//    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
//        return 0
//    }
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
//}

