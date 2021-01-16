//
//  OrderSuccessVC.swift
//  Dayshee
//
//  Created by haiphan on 11/15/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class OrderSuccessVC: UIViewController {

    @IBOutlet weak var btHome: UIButton!
    @IBOutlet weak var btDetailOrder: UIButton!
    var order: OrderCart?
    private let disposeBag = DisposeBag()
    @IBOutlet weak var lbOrderCode: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var lbTimeExpected: UILabel!
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
extension OrderSuccessVC {
    private func visualize() {
        let buttonLeft = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
        buttonLeft.setImage(UIImage(named: "ic_arrow_left_black"), for: .normal)
        buttonLeft.contentEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        let leftBarButton = UIBarButtonItem(customView: buttonLeft)

        navigationItem.leftBarButtonItem = leftBarButton
        buttonLeft.rx.tap.bind { _ in
            self.navigationController?.popViewController()
        }.disposed(by: disposeBag)

        title = ""
        
        let img: UIImage = UIImage(named: "ic_home") ?? UIImage()
        self.btHome.imageView?.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(15)
            make.left.equalToSuperview().inset(25)
        })
        self.btHome.setImage(img, for: .normal)
        self.lbOrderCode.text = "\(order?.id ?? 0)"
        self.lbTime.text = "\(order?.createdAt ?? "")"
        self.lbTimeExpected.text = "\(order?.expectedDeliveryAt ?? "")"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                                        NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 19.0) ?? UIImage() ]
        
    }
    private func setupRX() {
        self.btHome.rx.tap.bind { _ in
            let vc = BaseTabbarViewController()
            vc.hidesBottomBarWhenPushed = false
            self.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: disposeBag)
        
        self.btDetailOrder.rx.tap.bind { _ in
            let vc = BaseTabbarViewController()
            vc.hidesBottomBarWhenPushed = false
            vc.selectedIndex = 1
            self.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: disposeBag)
        
    }
}


