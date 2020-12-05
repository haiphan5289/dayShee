//
//  PDProduct.swift
//  Dayshee
//
//  Created by paxcreation on 11/9/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class PDProduct: UIView, UpdateDisplayProtocol, DisplayStaticHeightProtocol {
    static var height: CGFloat { return 0 }
    static var bottom: CGFloat { return 0 }
    static var automaticHeight: Bool { return true }
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var didSelectIndex: ((Int) -> Void)?
    var selectViewAll: (() -> Void)?
    private var dataSource: BehaviorRelay<[Product]> = BehaviorRelay.init(value: [])
    private var mSource: [Product] = []
    private let heightCell = 160
    private let disposeBag = DisposeBag()
}
extension PDProduct: Weakifiable {
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
extension PDProduct {
    func setupDisplay(item: [Product]?) {
        guard let item = item else {
            return
        }
        self.dataSource.accept(item)
        self.mSource = item
    }
    
    private func setupRX() {
        self.dataSource.asObservable()
            .bind(to: collectionView.rx.items(cellIdentifier: PDProductCell.identifier, cellType: PDProductCell.self)) { row, data, cell in
                cell.lbPrice.text = data.maxPrice?.currency
                cell.lbPriceDiscount.text = data.minPrice?.currency
                cell.lbName.text = data.name ?? ""
                guard let textUrl = data.imageURL, let url = URL(string: textUrl) else {
                    return
                }
                cell.imgProduct.kf.setImage(with: url)
        }.disposed(by: disposeBag)
    }
    private func visualize() {
        collectionView.delegate = self
        collectionView.register(PDProductCell.nib, forCellWithReuseIdentifier: PDProductCell.identifier)
    }
    func setupUI(title: String) {
        lbTitle.text = title
    }
}
extension PDProduct: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Int(self.collectionView.bounds.width - 20) / 3, height: heightCell)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let id = self.mSource[indexPath.row].id {
            self.didSelectIndex?(id)
        }
    }
}

