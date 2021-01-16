//
//  NotificationDetailVC.swift
//  Dayshee
//
//  Created by paxcreation on 11/17/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NotificationDetailVC: UIViewController, ActivityTrackingProgressProtocol {

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var tvContent: UITextView!
    private var readNotifcation: PublishSubject<ReadNotificationModel> = PublishSubject.init()
    private var msgAlert: PublishSubject<String> = PublishSubject.init()
    private var err: PublishSubject<ErrorService> = PublishSubject.init()
    var item: NotificationModel?
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
extension NotificationDetailVC {
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
                                                                        NSAttributedString.Key.font: UIFont(name: "Montserrat-Medium", size: 15.0) ?? UIImage() ]
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "ColorApp")
        let vLine: UIView = UIView(frame: .zero)
        vLine.backgroundColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
        self.view.addSubview(vLine)
        vLine.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
        self.indicator.asObservable().bind(onNext: { (item) in
            item ? LoadingManager.instance.show() : LoadingManager.instance.dismiss()
        }).disposed(by: disposeBag)
        
        self.err.asObservable().bind(onNext: weakify({ (err, wSelf) in
            wSelf.showAlert(title: nil, message: err.message)
        })).disposed(by: disposeBag)
        
        self.msgAlert.asObservable().bind(onNext: weakify({ (msg, wSelf) in
//            wSelf.showAlert(title: nil, message: msg)
        })).disposed(by: disposeBag)
        
        guard  let item = self.item, let id = item.id else {
            return
        }
        self.lbTitle.text = item.notificationType?.title
        self.tvContent.text = item.notificationType?.message
        self.lbTime.text = item.updatedAt
        
        let p: [String: Any] = ["id": id]
        RequestService.shared.APIData(ofType: OptionalMessageDTO<ReadNotificationModel>.self,
                                      url: APILink.readNotifcation.rawValue,
                                      parameters: p,
                                      method: .post)
            .trackProgressActivity(self.indicator)
            .bind { (result) in
                                        switch result {
                                        case .success(let value):
                                            guard let data = value.data, let item = data else {
                                                return
                                            }
                                            self.readNotifcation.onNext(item)
                                            self.msgAlert.onNext(value.message ?? "")
                                        case .failure(let err):
                                            self.err.onNext(err)
                                        }}.disposed(by: disposeBag)
    }
    private func setupRX() {
       
    }
    
    
}
