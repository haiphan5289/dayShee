//
//  FillterVC.swift
//  Dayshee
//
//  Created by paxcreation on 11/16/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Cosmos
import RangeSeekSlider

enum RouterFilter {
    case home
    case search
}

protocol FilterDelegate {
    func filterProduct(filter: FilterMode?)
}

class FillterVC: UIViewController {
    
    @IBOutlet weak var btReset: UIButton!
    @IBOutlet weak var switchNew: UISwitch!
    @IBOutlet weak var switchMostRate: UISwitch!
    @IBOutlet weak var switchBuyMost: UISwitch!
    @IBOutlet weak var rangeSlider: RangeSeekSlider!
    @IBOutlet weak var btApply: UIButton!
    @IBOutlet weak var vRating: CosmosView!
    @IBOutlet weak var btDismiss: UIButton!
    var delegate: FilterDelegate?
    var type: RouterFilter = .search
    var firstCategory: ProductHomeModel?
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        visualize()
        setupRX()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
}
extension FillterVC {
    private func visualize() {
        let buttonLeft = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
        buttonLeft.setImage(UIImage(named: "ic_arrow_left_black"), for: .normal)
        buttonLeft.contentEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        let leftBarButton = UIBarButtonItem(customView: buttonLeft)
        
        navigationItem.leftBarButtonItem = leftBarButton
        buttonLeft.rx.tap.bind { _ in
            self.navigationController?.popViewController()
        }.disposed(by: disposeBag)
        
        title = "Bộ lọc"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                                        NSAttributedString.Key.font: UIFont(name: "Montserrat-Medium", size: 15) ?? UIImage() ]
//        if let filter = DataLocal.share.filterMode {
//            self.rangeSlider.selectedMinValue = CGFloat(filter.minPrice ?? 0)
//            self.rangeSlider.selectedMaxValue = CGFloat(filter.maxPrice ?? 0)
//        }
        
    }
    private func setupRX() {
        
        self.btApply.rx.tap.bind(onNext: weakify({ (wSelf) in
            var filter = FilterMode()
            filter.minPrice = Double(self.rangeSlider.selectedMinValue)
            filter.maxPrice = Double(self.rangeSlider.selectedMaxValue)
            filter.isNew = self.switchNew.isOn
            filter.buyMost = self.switchBuyMost.isOn
            filter.rateMost = self.switchMostRate.isOn
            filter.rate = self.vRating.rating
            switch self.type {
            case .home:
                let vc = CategoryVC(nibName: "CategoryVC", bundle: nil)
                vc.filter = filter
                vc.typeCategory = .other
                guard  let first = wSelf.firstCategory else {
                    return
                }
                vc.categoryID = first.id ?? 0
                vc.titleCate = first.category ?? ""
                vc.typeRouterFilter = .home
                self.navigationController?.pushViewController(vc, animated: true)
            case .search:
                wSelf.delegate?.filterProduct(filter: filter)
                self.dismiss(animated: true, completion: nil)
            }
//            DataLocal.share.filterMode = filter
        })).disposed(by: disposeBag)
        
        self.btReset.rx.tap.bind { _ in
            self.switchNew.isOn = false
            self.switchMostRate.isOn = true
            self.switchBuyMost.isOn = false
            self.vRating.rating = 3
//            self.rangeSlider.selectedMinValue = 0
//            self.rangeSlider.selectedMaxValue = 10000000
//            DataLocal.share.filterMode = nil
//            self.delegate?.filterProduct(filter: nil)
            self.rangeSlider.setupStyle()
        }.disposed(by: disposeBag)
        
        self.btDismiss.rx.tap.bind { _ in
            switch self.type {
            case .home:
                self.navigationController?.popViewController()
            case .search:
                self.dismiss(animated: true, completion: nil)
            }
        }.disposed(by: disposeBag)
    }
}

