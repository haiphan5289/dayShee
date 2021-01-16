//
//  CatelogyView.swift
//  Dayshee
//
//  Created by paxcreation on 11/4/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class CatelogyView: UIView, UpdateDisplayProtocol, DisplayStaticHeightProtocol {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var hCollectionView: NSLayoutConstraint!
    var didSelectIndex: ((Int, String) -> Void)?
    var hasLoadData: Bool = false
    static var height: CGFloat { return 40 }
    static var bottom: CGFloat { return 0 }
    static var automaticHeight: Bool { return true }
    private var dataSource: BehaviorRelay<[ProductHomeModel]> = BehaviorRelay.init(value: [])
    private var mSource: [ProductHomeModel] = []
    private let heightCell = 115
    private let disposeBag = DisposeBag()
}
extension CatelogyView: Weakifiable {
    override func awakeFromNib() {
        super.awakeFromNib()
        hCollectionView.constant = 90
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
extension CatelogyView {
    func setupDisplay(item: [ProductHomeModel]?) {
        guard var item = item, item.count > 0 else {
            return
        }
        item = item.filter { $0.id != AddCategory.zalo.rawValue && $0.id != AddCategory.messenger.rawValue }
//        let iconZaloAndFB: ProductHomeModel = ProductHomeModel(id: 99, category: "Zalo / Facebook", iconURL: "kokkookko", hotProducts: [], products: [])
//        item.append(iconZaloAndFB)
        self.dataSource.accept(item)
        self.mSource = item
    }
    private func setupRX() {
        self.dataSource.asObservable()
            .bind(to: collectionView.rx.items(cellIdentifier: CatelogyCell.identifier, cellType: CatelogyCell.self)) { row, data, cell in
                cell.lbName.text = data.category
                self.hasLoadData = true
                guard let textUrl = data.iconURL, let url = URL(string: textUrl) else {
                    cell.img.image = UIImage()
                    return
                }
                cell.img.kf.setImage(with: url)
        }.disposed(by: disposeBag)
        
    }
    func updateHeightCell(table: UITableView, count: Int) {
        guard count > 0 else {
            self.hCollectionView.constant = 100
            return
        }
        var ratio = Int(count / 4)
        if count % 4 > 0 {
            ratio += 1
        }
        self.hCollectionView.constant = CGFloat(heightCell * ratio)
        table.beginUpdates()
        table.endUpdates()
    }
    private func visualize() {
        collectionView.delegate = self
        collectionView.register(CatelogyCell.nib, forCellWithReuseIdentifier: CatelogyCell.identifier)
    }
}
extension CatelogyView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Int(collectionView.bounds.width) / 4, height: heightCell)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = self.mSource[indexPath.row].id ?? 0
        let title = self.mSource[indexPath.row].category ?? ""
        self.didSelectIndex?(id, title)
    }
}
