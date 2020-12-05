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

protocol FilterDelegate {
    func filterProduct(filter: FilterMode)
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
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        visualize()
        setupRX()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
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
                                                                        NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 19.0) ?? UIImage() ]
        rangeSlider.handleColor = .black
        rangeSlider.handleImage = UIImage(named: "ic_range_slider")
        rangeSlider.minLabelColor = .black
        rangeSlider.maxLabelColor = .black
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
            wSelf.delegate?.filterProduct(filter: filter)
            self.dismiss(animated: true, completion: nil)
        })).disposed(by: disposeBag)
        
        self.btReset.rx.tap.bind { _ in
            self.switchNew.isOn = false
            self.switchMostRate.isOn = true
            self.switchBuyMost.isOn = false
            self.vRating.rating = 3
            self.rangeSlider.setupStyle()
        }.disposed(by: disposeBag)
        
        self.btDismiss.rx.tap.bind { _ in
            self.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)
    }
}

