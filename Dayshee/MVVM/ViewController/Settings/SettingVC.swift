//
//  SettingVC.swift
//  MVVM_2020
//
//  Created by Admin on 10/28/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import Kingfisher

enum IconSettingCell: Int {
    case addressDelivery
    case listProductFavourite
    case managePoints
    case listDiscount
    case notify
    case feedTechnical
    case policy
    case version
    case logout
    
    var image: UIImage? {
        switch self {
        case .addressDelivery:
            return UIImage(named: "ic_home_setting")
        case .listProductFavourite:
            return UIImage(named: "ic_heart")
        case .managePoints:
            return UIImage(named: "ic_award")
        case .listDiscount:
            return UIImage(named: "ic_percent")
        case .notify:
            return UIImage(named: "ic_bell")
        case .feedTechnical:
            return UIImage(named: "ic_edit")
        case .policy:
            return UIImage(named: "ic_feedback_technical")
        case .version:
            return UIImage(named: "ic_version")
        case .logout:
            return UIImage(named: "ic_logout")
        }
    }
    var text: String {
        switch self {
        case .addressDelivery:
            return "Danh sách địa chỉ giao hàng"
        case .listProductFavourite:
            return "Danh sách sản phẩm yêu thích"
        case .managePoints:
            return "Quản lý tích điểm"
        case .listDiscount:
            return "Danh sách khuyến mãi"
        case .notify:
            return "Cài đặt thông báo"
        case .feedTechnical:
            return "Phản hồi kỹ thuật"
        case .policy:
            return "Chính sách"
        case .version:
            return "Phiên bản ứng dụng"
        case .logout:
            return "Đăng xuất"
        }
    }
}

class SettingVC: BaseHiddenNavigationController {
    
    @IBOutlet weak var vHeader: UIView!
    private let disposeBag = DisposeBag()
    private let tableView : UITableView = UITableView(frame: .zero, style: .grouped)
    private let img: UIImageView = UIImageView(frame: .zero)
    private let lbName: UILabel = UILabel(frame: .zero)
    private let lbLevel: UILabel = UILabel(frame: .zero)
    private let lbGoal: UILabel = UILabel(frame: .zero)
    private var user: UserInfo?
    private let viewModel: SettingVM = SettingVM()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.checkLogin()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        setupRX()
    }
    
}
extension SettingVC {
    private func setupUI() {
        tableView.backgroundColor = .white
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.register(SettingCell.nib, forCellReuseIdentifier: SettingCell.identifier)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.vHeader.snp.bottom).inset(-10)
        }
        tableView.delegate = self
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                                        NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 19.0) ?? UIImage() ]
    }
    private func setupRX() {
        
        self.viewModel.indicator.asObservable().bind(onNext: { (item) in
            item ? LoadingManager.instance.show() : LoadingManager.instance.dismiss()
        }).disposed(by: disposeBag)
        
        self.viewModel.$isLogin.asObservable()
            .bind(onNext: weakify({ (isLogin, wSelf) in
                guard isLogin else {
                    wSelf.moveToLogin()
                    return
                }
                wSelf.viewModel.getDetail()
            })).disposed(by: disposeBag)
        
        Observable.just([1,2,3,4,5,6,7,8,9])
            .bind(to: tableView.rx.items(cellIdentifier: SettingCell.identifier, cellType: SettingCell.self)) {(row, element, cell) in
                guard let type = IconSettingCell(rawValue: row) else {
                    return
                }
                cell.img.image = type.image
                cell.lbText.text = type.text
                cell.imgArrow.isHidden = (row == 7) ? true : false
                cell.lbVersion.text = (row == 7) ? "1.0.0" : ""
            }.disposed(by: disposeBag)
        
        Observable.combineLatest(self.viewModel.$isLogin, self.viewModel.user)
            .asObservable().bind(onNext: weakify({ (item, wSelf) in
                guard item.0 else {
                    return
                }
                wSelf.user = item.1
                wSelf.updateUI(user: item.1)
            })).disposed(by: disposeBag)
        
        self.viewModel.$logOut.asObservable().bind { _ in
            self.viewModel.deleteAllData()
        }.disposed(by: disposeBag)
        
        self.tableView.rx.itemSelected.bind { (idx) in
            guard let type = IconSettingCell(rawValue: idx.row) else {
                return
            }
            var vc: UIViewController?
            switch type {
            case .addressDelivery:
                let v = ListAddressDeliveryVC(nibName: "ListAddressDeliveryVC", bundle: nil)
                v.typeListAddress = .setting
                vc = v
            case .listProductFavourite:
                vc = ListFavouriteVC(nibName: "ListFavouriteVC", bundle: nil)
            case .managePoints:
                vc = ManagePointsVC(nibName: "ManagePointsVC", bundle: nil)
            case .listDiscount:
                vc = ListDiscountVC(nibName: "ListDiscountVC", bundle: nil)
            case .notify:
                vc = NotifyVC(nibName: "NotifyVC", bundle: nil)
            case .feedTechnical:
                vc = TechnicalFeedBack(nibName: "TechnicalFeedBack", bundle: nil)
            case .policy:
                vc = PolicyVC(nibName: "PolicyVC", bundle: nil)
            case .version:
                //                vc = IntroduceAppVC(nibName: "IntroduceAppVC", bundle: nil)
                break
            case .logout:
                self.showAlert(title: "Thông báo", message: "Bạn có muốn đăng xuất", buttonTitles: ["Đóng", "Đồng ý"]) { [weak self] idx in
                    guard let wSelf = self else {
                        return
                    }
                    if idx == 1 {
                        wSelf.viewModel.getLogOut()
                    }
                }
            }
            
            guard let vcScreen = vc else {
                return
            }
            vcScreen.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vcScreen, animated: true)
        }.disposed(by: disposeBag)
    }
    private func updateUI(user: UserInfo) {
        lbName.text = user.name
        lbLevel.text = "Cấp độ: \(String(user.level ?? 0))"
        lbGoal.text = "Điểm tích luỹ: \(String(user.points ?? 0))"
        if let text = user.avatarURL, let url = URL(string: text) {
            img.kf.setImage(with: url)
        }
    }
    private func moveToLogin() {
        let vc = STORYBOARD_AUTH.instantiateViewController(withIdentifier: LoginVC.className) as! LoginVC
        vc.hidesBottomBarWhenPushed = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension SettingVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v: UIView = UIView()
        v.backgroundColor = .white
        
        img.backgroundColor = .red
        img.clipsToBounds = true
        img.layer.cornerRadius = 50
        v.addSubview(img)
        img.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(15)
            make.left.equalToSuperview().inset(15)
            make.width.height.equalTo(100)
        }
        
        lbName.textColor = .black
        lbName.font = UIFont(name: "Montserrat-Regular", size: 19.0)
        v.addSubview(lbName)
        
        lbName.snp.makeConstraints { (make) in
            make.top.equalTo(img)
            make.left.equalTo(img.snp.right).inset(-15)
            make.right.equalToSuperview().inset(15)
        }
        
        lbLevel.textColor = .black
        lbLevel.font = UIFont(name: "Montserrat-Regular", size: 15.0)
        v.addSubview(lbLevel)
        
        lbLevel.snp.makeConstraints { (make) in
            make.top.equalTo(lbName.snp.bottom).inset(-5)
            make.left.equalTo(img.snp.right).inset(-15)
            make.right.equalToSuperview().inset(15)
        }
        
        lbGoal.textColor = .black
        lbGoal.font = UIFont(name: "Montserrat-Regular", size: 15.0) 
        v.addSubview(lbGoal)
        
        lbGoal.snp.makeConstraints { (make) in
            make.top.equalTo(lbLevel.snp.bottom).inset(-5)
            make.left.equalTo(img.snp.right).inset(-15)
            make.right.equalToSuperview().inset(15)
        }
        
        let btProfile: UIButton = UIButton(frame: .zero)
        let underLineButton: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor.black,
            .underlineStyle: NSUnderlineStyle.single.rawValue]
        let attributeString = NSMutableAttributedString(string: "Xem trang cá nhân",
                                                        attributes: underLineButton)
        btProfile.setAttributedTitle(attributeString, for: .normal)
        v.addSubview(btProfile)
        
        btProfile.snp.makeConstraints { (make) in
            make.left.equalTo(img.snp.right).inset(-15)
            make.bottom.equalTo(img)
        }
        
        btProfile.rx.tap.bind { _ in
            guard let vc =  UIStoryboard(name: "ProfileDetail", bundle: nil).instantiateViewController(withIdentifier: ProfileDetailVC.className) as? ProfileDetailVC else {
                return
            }
            vc.hidesBottomBarWhenPushed = true
            vc.userInfo = self.user
            self.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: disposeBag)
        
        return v
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
}
