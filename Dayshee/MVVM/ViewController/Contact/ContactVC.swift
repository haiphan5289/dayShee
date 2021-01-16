//
//  ContactVC.swift
//  Dayshee
//
//  Created by paxcreation on 12/25/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ContactVC: UIViewController, ActivityTrackingProgressProtocol {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btConfirm: UIButton!
    @IBOutlet weak var hBottomTable: NSLayoutConstraint!
    @Replay(queue: MainScheduler.asyncInstance) private var msg: String
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
extension ContactVC {
    private func visualize() {
        let buttonLeft = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
        buttonLeft.setImage(UIImage(named: "ic_arrow_left_black"), for: .normal)
        buttonLeft.contentEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        let leftBarButton = UIBarButtonItem(customView: buttonLeft)

        navigationItem.leftBarButtonItem = leftBarButton
        buttonLeft.rx.tap.bind { _ in
            self.navigationController?.popViewController()
        }.disposed(by: disposeBag)

        title = "Liên Hệ"
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
        
        tableView.delegate = self
        tableView.register(ContactCell.nib, forCellReuseIdentifier: ContactCell.identifier)
    }
    private func setupRX() {
        
        self.indicator.asObservable().bind(onNext: { (item) in
            item ? LoadingManager.instance.show() : LoadingManager.instance.dismiss()
        }).disposed(by: disposeBag)
        
        Observable.just([1])
            .bind(to: tableView.rx.items(cellIdentifier: ContactCell.identifier, cellType: ContactCell.self)) {(row, element, cell) in
                
        }.disposed(by: disposeBag)
        
        let show = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification).map { KeyboardInfo($0) }
        let hide = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification).map { KeyboardInfo($0) }
        
        Observable.merge(show, hide).bind(onNext: weakify({ (keyboard, wSelf) in
            wSelf.runAnimate(by: keyboard)
        })).disposed(by: disposeBag)
        
        self.btConfirm.rx.tap.bind(onNext: weakify({ (wSelf) in
            guard let cell = wSelf.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ContactCell else {
                return
            }
            guard cell.tvContent.textColor == #colorLiteral(red: 0.06666666667, green: 0.06666666667, blue: 0.06666666667, alpha: 1) else {
                wSelf.showAlert(title: nil, message: "Vui lòng nhập nôi dung đánh giá")
                return
            }
            guard let name = cell.tfFullName.text, let email = cell.tfEmail.text, let content = cell.tvContent.text, content != "" else {
                wSelf.showAlert(title: nil, message: "Vui lòng điền đầy đủ thông tin")
                return
            }
            let p: [String: Any] = ["name": name, "email": email, "content": content]
            wSelf.postContact(p: p)
        })).disposed(by: disposeBag)
        
        self.$msg.asObservable().bind(onNext: weakify({ (msg, wSelf) in
            wSelf.showAlert(title: "Thông báo", message: msg)
        })).disposed(by: disposeBag)
    }
    private func postContact(p: [String: Any]) {
        RequestService.shared.APIData(ofType: OptionalMessageDTO<ContactModel>.self,
                                      url: APILink.contact.rawValue,
                                      parameters: p,
                                      method: .post)
            .trackProgressActivity(self.indicator)
            .bind { [weak self] (result) in
                guard let wSelf = self else {
                    return
                }
                switch result {
                case .success( let data):
                    wSelf.msg = data.message ?? ""
                case .failure( _):
                    break
                }}.disposed(by: disposeBag)
    }
    func runAnimate(by keyboarInfor: KeyboardInfo?) {
        guard let i = keyboarInfor else {
            return
        }
        let h = i.height
        let d = i.duration
        
        UIView.animate(withDuration: d) {
            self.hBottomTable.constant = (h > 0) ? (h - 150) : 15
        }
    }
}
extension ContactVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}
