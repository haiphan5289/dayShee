//
//  PDViewImage.swift
//  Dayshee
//
//  Created by haiphan on 11/8/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Cosmos

class PDViewImage: UIView {
    
    var addCart:((HomeDetailModel, Int) -> Void)?
    var btShareSelect:(() -> Void)?
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var viewRating: CosmosView!
    @IBOutlet weak var lbComment: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var btAddCart: UIButton!
    @IBOutlet weak var lbCount: UILabel!
    @IBOutlet weak var btPlus: UIButton!
    @IBOutlet weak var btMinus: UIButton!
    @IBOutlet weak var lbDiscountPrice: UILabel!
    @IBOutlet weak var lbDiscount: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var btLove: UIButton!
    @IBOutlet weak var btShare: UIButton!
    @IBOutlet weak var vDiscount: UIView!
    
    @VariableReplay private var dataSource: [ProductImageDetail] = []
    private var currentItem: HomeDetailModel?
    private var buttons: [UIButton] = []
    private var count: Int = 01
    private var currentIdx: Int = 0 {
        didSet {
            self.pageControl.currentPage = currentIdx
        }
    }
    private let disposeBag = DisposeBag()
}
extension PDViewImage: Weakifiable {
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
extension PDViewImage {
    private func visualize() {
        viewRating.settings.updateOnTouch = false
        viewRating.settings.fillMode = .half
        
        collectionView.delegate = self
        collectionView.register(BannerCell.nib, forCellWithReuseIdentifier: BannerCell.identifier)
        self.pageControl.numberOfPages = self.dataSource.count
        self.lbCount.text = "0\(self.count)"
    }
    private func setupRX() {
        self.$dataSource.asObservable()
            .bind(to: self.collectionView.rx.items(cellIdentifier: BannerCell.identifier, cellType: BannerCell.self)) { row, data, cell in
                guard let textUrl = data.imageURL, let url = URL(string: textUrl) else {
                    return
                }
                cell.img.kf.setImage(with: url)
        }.disposed(by: disposeBag)
        
        let add = btPlus.rx.tap.map { TypeAddCart.add }
        let remove = btMinus.rx.tap.map { TypeAddCart.remove }
        Observable.merge(add, remove).bind { [weak self] (type) in
            guard let wSelf = self else {
                return
            }
            if type == .remove && wSelf.count == 1 {
                return
            }
            (type == .add) ? (wSelf.count += 1) : (wSelf.count -= 1)
            wSelf.lbCount.text = (wSelf.count < 10) ? "0\(wSelf.count)" : "\(wSelf.count)"
        }.disposed(by: disposeBag)
        
        self.btAddCart.rx.tap.bind { _ in
            guard let item = self.currentItem else {
                return
            }
            self.addCart?(item, self.count)
        }.disposed(by: disposeBag)
        
        self.btShare.rx.tap.bind { _ in
            self.btShareSelect?()
        }.disposed(by: disposeBag)
                
    }
    func setupDisplay(item: HomeDetailModel?) {
        guard let item = item, let listImage = item.productImages, listImage.count > 0 else {
            return
        }
        self.currentItem = item
        self.pageControl.numberOfPages = listImage.count
        self.dataSource = listImage
        self.lbTitle.text = item.name
        
        var total: Double = 0
        item.productRatings?.forEach({ (t) in
            total += (t.rating ?? 0)
        })
        if let count = item.productRatings?.count, count > 0 {
            let i = total / Double(count)
            self.viewRating.rating = i
            self.lbComment.setTitle("(Xem \(count) nhận xét)", for: .normal)
        } else {
            self.viewRating.rating = 5
            self.lbComment.setTitle("", for: .normal)
        }
        setupStackView(options: item.productOptions ?? [])
    }
    private func setupStackView(options: [ProductOption]) {
        let v: UIView = UIView(frame: .zero)
        self.stackView.addArrangedSubview(v)
        for (index, element) in options.enumerated() {
            let bt: UIButton = UIButton(type: .custom)
            bt.tag = element.id ?? 0
            bt.clipsToBounds = true
            bt.layer.borderWidth = 0.5
            bt.backgroundColor =  (index == 0) ? .black : .white
            bt.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            bt.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            bt.setTitleColor((index == 0) ? .white : .black, for: .normal)
            bt.setTitle("    \(element.size ?? "")   ", for: .normal)
            bt.clipsToBounds = true
            bt.layer.cornerRadius = 15
            if index == 0 {
                if let price = element.salePrice, let rate = element.saleRate {
                    let saleRate = rate * 100
                    self.lbDiscount.text =  "\(saleRate)%"
                    self.lbDiscountPrice.text = price.currency
                    self.lbPrice.text = (element.price ?? 0).currency
                    self.vDiscount.isHidden = false
                } else {
                    self.lbDiscountPrice.text = (element.price ?? 0).currency
                    self.lbDiscount.text = ""
                }
                self.currentItem?.selectOption = element
            }
            self.stackView.addArrangedSubview(bt)
            self.buttons.append(bt)
            
            bt.rx.tap.bind {[weak self] _ in
                guard let wSelf = self else {
                    return
                }
                wSelf.buttons.forEach { (v) in
                    v.backgroundColor = (v.tag == element.id) ? .black : .white
                    v.setTitleColor((v.tag == element.id) ? .white : .black, for: .normal)
                }
                wSelf.currentItem?.selectOption = element
                
                guard let rate = element.saleRate, rate > 0 else {
                    wSelf.lbDiscount.text =  ""
                    wSelf.lbPrice.text = ""
                    wSelf.lbDiscountPrice.text = (element.price ?? 0).currency
                    return
                }
                wSelf.lbDiscount.text =  "\(rate)%"
                wSelf.lbDiscountPrice.text = (element.salePrice ?? 0).currency
                wSelf.lbPrice.text = (element.price ?? 0).currency
            }.disposed(by: self.disposeBag)
        }
    }
}
extension PDViewImage: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.bounds.width - 40 , height: 190)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        //Hiển thị page curent
        let page_number = targetContentOffset.pointee.x / (self.frame.width - 40)
        pageControl.currentPage = Int(page_number)
    }
}
