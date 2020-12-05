//
//  LoginViewController.swift
//  Knowitall
//
//  Created by thanhnguyen on 4/8/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import FirebaseMessaging
import RxSwift
import RxCocoa

enum TypeLogin: Int {
    case login
    case register
    case rate
    case formOfDelivery
}

protocol RateLoginDelegate {
    func callBack()
}
class LoginVC: UIViewController {
    //MARK: IBOUTLETS
    @IBOutlet weak var viewButton: UIView!
    @IBOutlet weak var vLine: UIView!
    @IBOutlet weak var btLoginHeader: UIButton!
    @IBOutlet weak var btRegister: UIButton!
    @IBOutlet weak var hViewNote: NSLayoutConstraint!
    @IBOutlet weak var stackViewNote: UIStackView!
    @IBOutlet weak var btSignIn: UIButton!
    @IBOutlet weak var btForgotPassword: UIButton!
    @IBOutlet weak var tfNumberPhone: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btShowPW: UIButton!
    @IBOutlet weak var viewNumberPhone: UIView!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var view8Characters: UIView!
    @IBOutlet weak var viewOneCharacter: UIView!
    @IBOutlet weak var viewNumber: UIView!
    @IBOutlet weak var img8: UIImageView!
    @IBOutlet weak var lb8: UILabel!
    @IBOutlet weak var im1Text: UIImageView!
    @IBOutlet weak var lb1Text: UILabel!
    @IBOutlet weak var imgNumber: UIImageView!
    @IBOutlet weak var lbNumber: UILabel!
    @IBOutlet var tap: UITapGestureRecognizer!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var vImg: UIView!
    
    
    //MARK: OTHER VARIABLES
    var typeLogin: TypeLogin = .login
    var delegateRate: RateLoginDelegate?
    private var isValid: Bool = false
    private let disposeBag = DisposeBag()
    private var isValid8Chacraters: PublishSubject<Bool> = PublishSubject.init()
    private var isValidChacratersUpcase: PublishSubject<Bool> = PublishSubject.init()
    private var isValidHaveNumber: PublishSubject<Bool> = PublishSubject.init()
    var viewModel = AuthenViewModel()
    //MARK: VIEW LIFE CYCLE
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        visualize()
        setupRX()
    }

}
extension LoginVC {
    func visualize() {
        let buttonLeft = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
        buttonLeft.setImage(UIImage(named: "ic_arrow_left_black"), for: .normal)
        buttonLeft.contentEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        let leftBarButton = UIBarButtonItem(customView: buttonLeft)

        navigationItem.leftBarButtonItem = leftBarButton
        buttonLeft.rx.tap.bind { _ in
            self.navigationController?.popViewController()
        }.disposed(by: disposeBag)
        
        self.btSignIn.imageView?.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(15)
        })
        self.btSignIn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        self.tfNumberPhone.placeholder = "Nhập số điện thoại"
        self.tfPassword.placeholder = "Nhập mật khẩu"
        self.tfPassword.isSecureTextEntry = true
        self.view8Characters.isHidden = true
        self.viewOneCharacter.isHidden = true
        self.viewNumber.isHidden = true
        self.hViewNote.constant = 0
        
        
        // Shadow Color and Radius
        btSignIn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        btSignIn.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        btSignIn.layer.shadowOpacity = 1.0
        btSignIn.layer.shadowRadius = 0.0
        btSignIn.layer.masksToBounds = false
        btSignIn.layer.cornerRadius = 4.0
        
        imgLogo.applyshadowWithCorner(containerView: self.vImg, cornerRadious: 10)
    }
    private func setupRX() {
        
        self.tap.rx.event.bind { _ in
            self.view.endEditing(true)
        }.disposed(by: disposeBag)
        
        self.viewModel.indicator.asObservable().bind(onNext: { (item) in
            item ? LoadingManager.instance.show() : LoadingManager.instance.dismiss()
        }).disposed(by: disposeBag)
        
        let btLoginHeader = self.btLoginHeader.rx.tap.map { TypeLogin.login }
        let btRegister = self.btRegister.rx.tap.map { TypeLogin.register }
        
        Observable.merge(btLoginHeader, btRegister).bind { [weak self] (type) in
            guard let wSelf = self else {
                return
            }
            UIView.animate(withDuration: 0.3) {
                wSelf.typeLogin = type
                wSelf.vLine.transform = CGAffineTransform(translationX:( wSelf.viewButton.bounds.width / 2) * CGFloat(type.rawValue)
                                                          , y: 0)
                wSelf.view8Characters.isHidden = (type.rawValue) > 0 ? false : true
                wSelf.viewOneCharacter.isHidden = (type.rawValue) > 0 ? false : true
                wSelf.viewNumber.isHidden = (type.rawValue) > 0 ? false : true
                wSelf.hViewNote.constant = (type.rawValue) > 0 ? 75 : 0
                wSelf.btSignIn.setTitle((type.rawValue) > 0 ? "Đăng kí" : "Đăng nhập", for: .normal)
                let img = UIImage(named: (type.rawValue) > 0 ? "ic_arrow_right" : "" )
                wSelf.btSignIn.setImage(img, for: .normal)
                wSelf.btForgotPassword.isHidden = (type.rawValue) > 0 ? true : false
            }
            wSelf.view.layoutIfNeeded()
        }.disposed(by: disposeBag)
        
        self.tfNumberPhone.rx.text.orEmpty.bind(onNext: weakify({ (value, wSelf) in
            guard value != "" else {
                wSelf.viewNumberPhone.layer.borderColor = #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 1)
                return
            }
            wSelf.viewNumberPhone.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        })).disposed(by: disposeBag)
        
        self.tfPassword.rx.text.orEmpty.bind(onNext: weakify({ (value, wSelf) in
            guard value != "" else {
                wSelf.viewPassword.layer.borderColor = #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 1)
                return
            }
            wSelf.viewPassword.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        })).disposed(by: disposeBag)
        
        let isPhoneValid = self.tfNumberPhone.rx.text.map { return self.isValidPhone(phone: $0 ?? "") }
        let isPasswordValid = self.tfPassword.rx.text.map { return self.isPassword(text: $0 ?? "") }
        
        Observable.combineLatest(isPhoneValid, isPasswordValid)
            .bind { [weak self] (isPhone, isPassword) in
                guard let wSelf = self else {
                    return
                }
                guard isPhone && isPassword else {
                    wSelf.isValid = false
                    return
                }
                wSelf.isValid = true
            }.disposed(by: disposeBag)
        
        self.btShowPW.rx.tap
            .bind(onNext: weakify({ (wSelf) in
                if wSelf.btShowPW.isSelected {
                    wSelf.btShowPW.setTitle("Hiện", for: .normal)
                    wSelf.tfPassword.isSecureTextEntry = true
                    wSelf.btShowPW.isSelected = false
                } else {
                    wSelf.btShowPW.setTitle("Ẩn", for: .normal)
                    wSelf.tfPassword.isSecureTextEntry = false
                    wSelf.btShowPW.isSelected = true
                }
            })).disposed(by: disposeBag)
        
        self.btSignIn.rx.tap.bind(onNext: weakify({ (wSelf) in
            guard let numberPhone = wSelf.tfNumberPhone.text,
                  let pass = wSelf.tfPassword.text else {
                return
            }
            guard wSelf.typeLogin == .register else {
                wSelf.loginAccount(numberPhone: numberPhone, password: pass)
                return
            }
            guard wSelf.isValid else {
                self.showAlert(title: "Thông báo", message: "Thông tin bạn nhập không hợp lệ")
                return
            }
            let p: [String: Any] = ["phone": numberPhone]
            self.viewModel.checkPhone(p: p)
        })).disposed(by: disposeBag)
        
        self.viewModel.checkPhone.asObservable().bind(onNext: weakify({ (isValid, wSelf) in
            guard isValid else {
                return
            }
            guard let numberPhone = wSelf.tfNumberPhone.text,
                  let pass = wSelf.tfPassword.text else {
                return
            }
            wSelf.moveToRegister(user: numberPhone, pass: pass)
        })).disposed(by: disposeBag)
        
        self.isValid8Chacraters.asObservable().bind(onNext: weakify({ (isValid, wSelf) in
            guard isValid else {
                wSelf.img8.image = UIImage(named: "ic_check")
                wSelf.lb8.textColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
                return
            }
            wSelf.img8.image = UIImage(named: "ic_check")
            wSelf.lb8.textColor = .black
        })).disposed(by: disposeBag)
        
        self.isValidChacratersUpcase.asObservable().bind(onNext: weakify({ (isValid, wSelf) in
            guard isValid else {
                wSelf.im1Text.image = UIImage(named: "ic_check")
                wSelf.lb1Text.textColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
                return
            }
            wSelf.im1Text.image = UIImage(named: "ic_check")
            wSelf.lb1Text.textColor = .black
        })).disposed(by: disposeBag)
        
        self.isValidHaveNumber.asObservable().bind(onNext: weakify({ (isValid, wSelf) in
            guard isValid else {
                wSelf.imgNumber.image = UIImage(named: "ic_check")
                wSelf.lbNumber.textColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
                return
            }
            wSelf.imgNumber.image = UIImage(named: "ic_check")
            wSelf.lbNumber.textColor = .black
        })).disposed(by: disposeBag)
        
        self.viewModel.userInfo.asObservable().bind(onNext: weakify({ (item, wSelf) in
                guard wSelf.typeLogin != .rate else {
                    wSelf.delegateRate?.callBack()
                    return
                }
                self.navigationController?.popViewController()
//                let vc = VerifyPhoneVC(nibName: "VerifyPhoneVC", bundle: nil)
//                vc.hidesBottomBarWhenPushed = true
//                wSelf.navigationController?.pushViewController(vc, animated: true)
            })).disposed(by: disposeBag)
        
        self.viewModel.err.asObservable().bind(onNext: weakify({ (err, wSelf) in
            self.showAlert(title: "Thông báo", message: err.message)
        })).disposed(by: disposeBag)
        
        self.btForgotPassword.rx.tap.bind(onNext: weakify({ (wSelf) in
            let vc = ForgotPasswordVC(nibName: "ForgotPasswordVC", bundle: nil)
            vc.hidesBottomBarWhenPushed = true
            vc.delegate = self
            wSelf.navigationController?.pushViewController(vc, animated: true)
        })).disposed(by: disposeBag)
    }
    private func loginAccount(numberPhone: String, password: String) {
        let p: [String : Any] = [
            "phone": numberPhone,
            "password" : password,
            "device_token" : Messaging.messaging().fcmToken ?? "",
            "mac_address": UIDevice.current.identifierForVendor?.uuidString ?? ""
        ]
        self.viewModel.getLogin(p: p)
    }
    private func moveToRegister(user: String, pass: String) {
        let vc = RegisterVC(nibName: "RegisterVC", bundle: nil)
        vc.phone = user
        vc.password = pass
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    private func isPassword(text: String) -> Bool {
        self.isValid8Chacraters.onNext((text.count >= 8) ? true : false)
        self.isValidChacratersUpcase.onNext(text.isUpdateContain)
        self.isValidHaveNumber.onNext(text.isHaveNumber)
        guard text.count >= 8 && text.isUpdateContain && text.isHaveNumber else {
            return false
        }
        return true
    }
}
extension LoginVC: LoginDelegate {
    func callBack() {
        let me = self
        me.hidesBottomBarWhenPushed = false
        self.navigationController?.popToViewController(self, animated: true)
    }
}
