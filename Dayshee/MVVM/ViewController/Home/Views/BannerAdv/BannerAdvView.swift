//
//  BannerAdvView.swift
//  Dayshee
//
//  Created by paxcreation on 12/30/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//
import UIKit
import RxCocoa
import RxSwift
import Kingfisher


class BannerAdvView: UIView, UpdateDisplayProtocol, DisplayStaticHeightProtocol {
    var didSelectIndex: ((BannerAdv) -> Void)?
    var typeImageRatioBanner: TypeImageRatioBanner = .other
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    static var height: CGFloat { return 0 }
    static var bottom: CGFloat { return 0 }
    static var automaticHeight: Bool { return false }
    static var ratio32: Bool { return true }
    private let disposeBag = DisposeBag()
    private var dataSource: BehaviorRelay<[BannerAdv]> = BehaviorRelay.init(value: [])
    private var list: [BannerAdv] = []
    private var currentIdx: Int = 0 {
        didSet {
            self.pageControl.currentPage = currentIdx
        }
    }
    private var disposeScroll: Disposable?
    func setupDisplay(item: BannerAdv?) {
        guard let item = item else {
            return
        }
//        self.pageControl.numberOfPages = item.count
        self.dataSource.accept([item])
        self.list = [item]
    }
}
extension BannerAdvView: Weakifiable {
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
extension BannerAdvView {
    private func setupRX() {
        autoScroll()
        self.dataSource
            .bind(to: self.collectionView.rx.items(cellIdentifier: BannerCell.identifier, cellType: BannerCell.self)) { row, data, cell in
                guard let textUrl = data.imageURL, let url = URL(string: textUrl) else {
                    return
                }
                cell.img.kf.setImage(with: url)
        }.disposed(by: disposeBag)
    }
    private func visualize() {
        collectionView.delegate = self
        collectionView.register(BannerCell.nib, forCellWithReuseIdentifier: BannerCell.identifier)
        collectionView.layer.cornerRadius = 10
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
extension BannerAdvView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
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

