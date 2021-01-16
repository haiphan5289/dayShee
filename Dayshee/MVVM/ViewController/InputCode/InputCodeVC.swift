//
//  InputCodeVC.swift
//  Dayshee
//
//  Created by paxcreation on 11/17/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa
import KWVerificationCodeView

protocol ForgotPassworđelgate {
    func callBack()
}

class InputCodeVC: UIViewController {

    @IBOutlet weak var btNext: UIButton!
    @IBOutlet weak var textCode: KWVerificationCodeView!
    @IBOutlet weak var bottomButton: NSLayoutConstraint!
    var delegate: ForgotPassworđelgate?
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
extension InputCodeVC {
    private func visualize() {
        let buttonLeft = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
        buttonLeft.setImage(UIImage(named: "ic_arrow_left_black"), for: .normal)
        buttonLeft.contentEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        let leftBarButton = UIBarButtonItem(customView: buttonLeft)

        let lbTitle: UILabel = UILabel(frame: .zero)
        lbTitle.text = "Nhập mã xác thực"
        lbTitle.font = UIFont(name: "Montserrat-SemiBold", size: 20)
        let leftButton2 = UIBarButtonItem(customView: lbTitle)
        
        navigationItem.leftBarButtonItems = [leftBarButton, leftButton2]
        buttonLeft.rx.tap.bind { _ in
            self.navigationController?.popViewController()
        }.disposed(by: disposeBag)

        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                                        NSAttributedString.Key.font: UIFont(name: "Montserrat-SemiBold", size: 15.0) ?? UIImage() ]
        let img: UIImage = UIImage(named: "ic_arrow_right") ?? UIImage()
        self.btNext.imageView?.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(30)
        })
        self.btNext.setImage(img, for: .normal)

    }
    private func setupRX() {
        let show = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification).map { KeyboardInfo($0) }
        let hide = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification).map { KeyboardInfo($0) }
        
        Observable.merge(show, hide).bind(onNext: weakify({ (keyboard, wSelf) in
            wSelf.runAnimate(by: keyboard)
        })).disposed(by: disposeBag)
        
        self.btNext.rx.tap.bind(onNext: weakify({ (wSelf) in
            guard wSelf.textCode.hasValidCode() else {
                wSelf.showAlert(title: nil, message: "Code của bạn chưa hợp lệ")
                return
            }
            let vc = NewPasswordVC(nibName: "NewPasswordVC", bundle: nil)
            vc.hidesBottomBarWhenPushed = true
            vc.delegate = self
            wSelf.navigationController?.pushViewController(vc, animated: true)
        })).disposed(by: disposeBag)
    }
    func runAnimate(by keyboarInfor: KeyboardInfo?) {
        guard let i = keyboarInfor else {
            return
        }
        let h = i.height
        let d = i.duration
        
        UIView.animate(withDuration: d) {
            self.bottomButton.constant = (h > 0) ? h : 40
        }
    }
}
extension InputCodeVC: InputCodeDelegate {
    func callBack() {
        let me = self
        me.hidesBottomBarWhenPushed = false
        self.delegate?.callBack()
    }
}
