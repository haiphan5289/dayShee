//
//  CategoryListView.swift
//  Dayshee
//
//  Created by haiphan on 11/8/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class CategoryListView: UIView {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @VariableReplay var dataSource: [CategoryHome] = []
    var selectCategoryID: PublishSubject<Int> = PublishSubject.init()
    var mSelectCategoryID: Int?
    private let disposeBag = DisposeBag()
}
extension CategoryListView: Weakifiable {
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
extension CategoryListView {
    private func visualize() {
        collectionView.delegate = self
        collectionView.register(CategoryListCell.nib, forCellWithReuseIdentifier: CategoryListCell.identifier)
    }
    private func setupRX() {
        self.$dataSource.asObservable()
            .bind(to: collectionView.rx.items(cellIdentifier: CategoryListCell.identifier, cellType: CategoryListCell.self)) { row, data, cell in
                guard let id = data.id else {
                    return
                }
                cell.lbName.text = data.category
                cell.leftText.constant = (row == 0) ? 20 : 0
                self.changeUICell(cell: cell, categoryID: id, selectCategoryID: self.mSelectCategoryID ?? 1)
            }.disposed(by: disposeBag)
    }
    private func changeUICell(cell: CategoryListCell, categoryID: Int, selectCategoryID: Int) {
        if categoryID == selectCategoryID {
            cell.lbName.textColor = .black
            cell.vLine.backgroundColor = .black
        } else {
            cell.lbName.textColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
            cell.vLine.backgroundColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
        }
    }
    private func getTextSize(text: String) -> CGRect{
        let size = CGSize(width: 10000, height: 50)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)], context: nil)
    }
}
extension CategoryListView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.getTextSize(text: self.dataSource[indexPath.row].category ?? "")
        return CGSize(width: width.width + 60, height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let id = self.dataSource[indexPath.row].id else {
            return
        }
        self.mSelectCategoryID = id
        self.selectCategoryID.onNext(id)
        self.collectionView.reloadData()
    }
}


