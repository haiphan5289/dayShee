//
//  QuestionVC.swift
//  Dayshee
//
//  Created by paxcreation on 11/9/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class QuestionVC: UIViewController, ActivityTrackingProgressProtocol {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var btSubmit: UIButton!
    var id: Int?
    @Replay(queue: MainScheduler.asyncInstance) private var submit: Bool
    @Replay(queue: MainScheduler.asyncInstance) private var err: ErrorService
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
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
extension QuestionVC {
    private func visualize() {
        let buttonLeft = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
        buttonLeft.setImage(UIImage(named: "ic_arrow_left_black"), for: .normal)
        buttonLeft.contentEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        let leftBarButton = UIBarButtonItem(customView: buttonLeft)
        
        navigationItem.leftBarButtonItem = leftBarButton
        buttonLeft.rx.tap.bind { _ in
            self.navigationController?.popViewController()
        }.disposed(by: disposeBag)
        
        title = "Gửi câu hỏi cho chúng tôi"
        self.textView.text = "Nhập câu hỏi"
        self.textView.textColor = #colorLiteral(red: 0.7921568627, green: 0.7921568627, blue: 0.7921568627, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                        NSAttributedString.Key.font: UIFont(name: "Montserrat-Medium", size: 15.0) ?? UIImage() ]
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "ColorApp")
    }
    private func setupRX() {
        let token = Token()
        
        if !token.tokenExists {
            let vc = self
            vc.hidesBottomBarWhenPushed = false
            let login = STORYBOARD_AUTH.instantiateViewController(withIdentifier: LoginVC.className) as! LoginVC
            login.hidesBottomBarWhenPushed = false
            login.typeLogin = .rate
            login.delegateRate = self
            self.navigationController?.pushViewController(login, animated: true)
        }
        
        textView.textColor = #colorLiteral(red: 0.3882352941, green: 0.4470588235, blue: 0.5019607843, alpha: 1)
        textView.rx.didBeginEditing.bind(onNext: weakify { (wSelf) in
            self.textView.text = nil
            self.textView.textColor = #colorLiteral(red: 0.06666666667, green: 0.06666666667, blue: 0.06666666667, alpha: 1)
        }).disposed(by: disposeBag)
        
        self.btSubmit.rx.tap.bind { _ in
            guard let id = self.id else {
                return
            }
            let p: [String: Any] = ["product_id": id, "question": self.textView.text ?? "" ]
            self.submitQA(p: p)
        }.disposed(by: disposeBag)
        
        self.$submit.asObservable().bind(onNext: weakify({ (isOk, wSelf) in
            guard isOk else {
                return
            }
            wSelf.showAlert(title: nil, message: "Cám ơn bạn đã đặt câu hỏi")
        })).disposed(by: disposeBag)
        
        self.$err.asObservable().bind(onNext: weakify({ (err, wSelf) in
            wSelf.showAlert(title: nil, message: err.message)
        })).disposed(by: disposeBag)
    }
    private func submitQA(p: [String: Any]) {
        RequestService.shared.APIData(ofType: OptionalMessageDTO<ProductFAQ>.self,
                                      url: APILink.faq.rawValue,
                                      parameters: p,
                                      method: .post)
            .trackProgressActivity(self.indicator)
            .bind { [weak self] (result) in
                guard let wSelf = self else {
                    return
                }
                switch result {
                case .success( _):
                    wSelf.submit = true
                case .failure(let err):
                    wSelf.err = err
                }}.disposed(by: disposeBag)
        
    }
}
extension QuestionVC: RateLoginDelegate {
    func callBack() {
        let vc = self
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.popToViewController(self, animated: true)
    }
}
