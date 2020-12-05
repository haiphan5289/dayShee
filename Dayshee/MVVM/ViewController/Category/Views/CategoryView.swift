//
//  CategoryView.swift
//  Dayshee
//
//  Created by haiphan on 11/7/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DZNEmptyDataSet

class CategoryView: UIView , UpdateDisplayProtocol, DisplayStaticHeightProtocol{
    static var height: CGFloat { return 260 }
    static var bottom: CGFloat { return 0 }
    static var automaticHeight: Bool { return false }
    
    @IBOutlet weak var collectionView: UICollectionView!
    var didSelectIndex: ((Int) -> Void)?
    var selectViewAll: (() -> Void)?
    private var dataSource: BehaviorRelay<[Product]> = BehaviorRelay.init(value: [])
    private var mDataSource: [Product] = []
    private let heightCell = 160
    
    private let disposeBag = DisposeBag()
}
extension CategoryView: Weakifiable {
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
extension CategoryView {
    func setupDisplay(item: [Product]?) {
        guard let item = item else {
            return
        }
        self.mDataSource = item
        self.collectionView.reloadData()
    }
    
    private func setupRX() {
    }
    private func visualize() {
        let vLine: UIView = UIView(frame: .zero)
        vLine.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        self.addSubview(vLine)
        vLine.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(self.collectionView.snp.bottom).inset(-10)
        }
        
        let lbAllProduct: UILabel = UILabel(frame: .zero)
        lbAllProduct.text = "Tất cả sản phẩm"
        lbAllProduct.font = UIFont.systemFont(ofSize: 17)
        self.addSubview(lbAllProduct)
        lbAllProduct.snp.makeConstraints { (make) in
            make.left.equalTo(self.collectionView)
            make.top.equalTo(vLine.snp.bottom).inset(-10)
            make.bottom.equalToSuperview().inset(10)
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        collectionView.register(ProductViewCell.nib, forCellWithReuseIdentifier: ProductViewCell.identifier)
    }
}
extension CategoryView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (Int(self.bounds.width) - 20) / 3, height: 165)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

}
extension CategoryView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.mDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: ProductViewCell.self, for: indexPath)
        let data = self.mDataSource[indexPath.row]
        cell.lbPrice.text = data.maxPrice?.currency
        cell.lbPriceDiscount.text = data.minPrice?.currency
        cell.lbName.text = data.name ?? ""
        if let textUrl = data.imageURL, let url = URL(string: textUrl) {
            cell.imgProduct.kf.setImage(with: url)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let id = self.mDataSource[indexPath.row].id {
            self.didSelectIndex?(id)
        }
    }
    
}
extension CategoryView: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "Hiện tại chưa có sản phẩm"
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                   NSAttributedString.Key.font: UIFont.systemFont(ofSize: 19) ]
        let t = NSAttributedString(string: text, attributes: titleTextAttributes)
        return t
    }
}

