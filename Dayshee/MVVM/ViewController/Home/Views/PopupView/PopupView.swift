//
//  PopupView.swift
//  Dayshee
//
//  Created by haiphan on 12/29/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class PopupView: UIView {
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btClose: UIButton!
    var didSelectIndex: ((Banner) -> Void)?
    var closeView: (() -> Void)?
    private var dataSource: BehaviorRelay<[Banner]> = BehaviorRelay.init(value: [])
    private var list: [Banner] = []
    private let tap: UITapGestureRecognizer = UITapGestureRecognizer()
    private var currentIdx: Int = 0 {
        didSet {
            self.pageControl.currentPage = currentIdx
        }
    }
    private var disposeScroll: Disposable?
    private let disposeBag = DisposeBag()
}
extension PopupView: Weakifiable {
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
extension PopupView {
    func setupDisplay(item: [Banner]?) {
        guard let item = item, item.count > 0 else {
            return
        }
        self.pageControl.numberOfPages = item.count
        self.dataSource.accept(item)
        self.list = item
    }
    
    private func setupRX() {
        autoScroll()
        self.dataSource
            .bind(to: self.collectionView.rx.items(cellIdentifier: PopupViewCell.identifier, cellType: PopupViewCell.self)) { row, data, cell in
                guard let textUrl = data.bannerURL, let url = URL(string: textUrl) else {
                    return
                }
                cell.img.kf.setImage(with: url)
        }.disposed(by: disposeBag)
        
        self.btClose.rx.tap.bind { _ in
            self.closeView?()
        }.disposed(by: disposeBag)
        
        tap.rx.event.bind { _ in
            self.closeView?()
        }.disposed(by: disposeBag)
    }
    private func visualize() {
        collectionView.delegate = self
        collectionView.register(PopupViewCell.nib, forCellWithReuseIdentifier: PopupViewCell.identifier)
        
        self.addGestureRecognizer(self.tap)
        tap.cancelsTouchesInView = false
    }
    private func clearAction() {
        disposeScroll?.dispose()
    }
    private func autoScroll() {
        disposeScroll?.dispose()
        
        disposeScroll = Observable<Int>.interval(.seconds(5), scheduler: MainScheduler.asyncInstance)
            .bind(onNext: weakify({ (_, wSelf) in
                guard wSelf.dataSource.value.count > 0 else {
                    return
                }
                var next = wSelf.currentIdx + 1
                let count = wSelf.dataSource.value.count
                next = next <= count - 1 ? next : 0
                wSelf.currentIdx = next
                wSelf.collectionView.scrollToItem(at: IndexPath(item: next, section: 0), at: .centeredHorizontally, animated: true)
            }))
    }
}
extension PopupView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.collectionView.bounds.size
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        disposeScroll?.dispose()
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.autoScroll()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.list[indexPath.row]
        self.didSelectIndex?(item)
    }
}
