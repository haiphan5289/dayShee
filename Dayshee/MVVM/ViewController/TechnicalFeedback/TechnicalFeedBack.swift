//
//  TechnicalFeedBack.swift
//  Dayshee
//
//  Created by paxcreation on 11/17/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TechnicalFeedBack: UIViewController {
    
    @IBOutlet weak var tvContent: UITextView!
    @IBOutlet weak var tfFullName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var btSendFeedback: UIButton!
    private var contact: PublishSubject<Contact> = PublishSubject.init()
    private var err: PublishSubject<ErrorService> = PublishSubject.init()
    
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
extension TechnicalFeedBack {
    private func visualize() {
        let buttonLeft = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
        buttonLeft.setImage(UIImage(named: "ic_arrow_left_black"), for: .normal)
        buttonLeft.contentEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        let leftBarButton = UIBarButtonItem(customView: buttonLeft)
        
        navigationItem.leftBarButtonItem = leftBarButton
        buttonLeft.rx.tap.bind { _ in
            self.navigationController?.popViewController()
        }.disposed(by: disposeBag)
        
        title = "Phản hồi kỹ thuật"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                                        NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 19.0) ?? UIImage() ]
        let vLine: UIView = UIView(frame: .zero)
        vLine.backgroundColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
        self.view.addSubview(vLine)
        vLine.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
        self.tvContent.text = "Nhập nội dung đánh giá của bạn vào đây"
        self.tvContent.textColor = #colorLiteral(red: 0.3882352941, green: 0.4470588235, blue: 0.5019607843, alpha: 1)
    }
    
    private func setupRX() {
        tvContent.rx.didBeginEditing.bind(onNext: weakify { (wSelf) in
            wSelf.tvContent.text = nil
            wSelf.tvContent.textColor = #colorLiteral(red: 0.06666666667, green: 0.06666666667, blue: 0.06666666667, alpha: 1)
        }).disposed(by: disposeBag)
        
        self.contact.asObservable().bind(onNext: weakify({ (_, wSelf) in
            wSelf.showAlert(title: "Thông báo", message: "Bạn gửi phản hồi thành công")
        })).disposed(by: disposeBag)
        
        self.btSendFeedback.rx.tap.bind(onNext: weakify({ (wSelf) in
            guard let email = wSelf.tfEmail.text,
                  let name = wSelf.tfFullName.text,
                  let content = wSelf.tvContent.text, content != "", email != "" , name != "" else {
                wSelf.showAlert(title: "Thông báo", message: "Vui lòng thông tin nhập hợp lệ")
                return
            }
            let p: [String: Any] = ["name": name, "email": email, "content": content]
            wSelf.sendFeedback(p: p)
        })).disposed(by: disposeBag)
        
    }
    func sendFeedback(p: [String : Any]) {
        RequestService.shared.APIData(ofType: OptionalMessageDTO<Contact>.self,
                                      url: APILink.contact.rawValue,
                                      parameters: p,
                                      method: .post)
            .bind { [weak self] (result) in
                switch result {
                case .success(let data):
                    guard  let wSelf = self else {
                        return
                    }
                    guard let data = data.data, let list = data else {
                        return
                    }
                    wSelf.contact.onNext(list)
                case .failure(let err):
                    self?.err.onNext(err)
                }
            }.disposed(by: disposeBag)
    }
}
