//
//  BannerVC.swift
//  Dayshee
//
//  Created by paxcreation on 11/10/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class BannerVC: UIViewController {

    @IBOutlet weak var imgUrl: UIImageView!
    @IBOutlet weak var tvContent: UITextView!
    private let disposeBag = DisposeBag()
    var item: Banner?
    override func viewDidLoad() {
        super.viewDidLoad()
        visualize()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
extension BannerVC {
    private func visualize() {
        let buttonLeft = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
        buttonLeft.setImage(UIImage(named: "ic_arrow_left_black"), for: .normal)
        buttonLeft.contentEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        let leftBarButton = UIBarButtonItem(customView: buttonLeft)
        
        navigationItem.leftBarButtonItem = leftBarButton
        buttonLeft.rx.tap.bind { _ in
            self.navigationController?.popViewController()
        }.disposed(by: disposeBag)
        
        title = "Chi tiết"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                        NSAttributedString.Key.font: UIFont(name: "Montserrat-Medium", size: 15) ?? UIImage() ]
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "ColorApp")
        self.tvContent.text = item?.datumDescription
        
        guard let textUrl = item?.bannerURL, let url = URL(string: textUrl) else {
            return
        }
        imgUrl.kf.setImage(with: url)
    }
    private func setupRX() {
    
    }
}
