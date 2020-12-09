//
//  ProfileDetailVC.swift
//  Dayshee
//
//  Created by paxcreation on 11/2/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileDetailVC: UITableViewController {
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfAddress: UITextField!
    @IBOutlet weak var tfBirthday: UITextField!
    @IBOutlet var listTextField: [UITextField]!
    @IBOutlet weak var tvZone: UITextView!
    private let img: UIImageView = UIImageView(frame: .zero)
    let btSelectImage: UIButton = UIButton(type: .custom)
    private let lbName: UILabel = UILabel(frame: .zero)
    private let lbLevel: UILabel = UILabel(frame: .zero)
    private let lbGoal: UILabel = UILabel(frame: .zero)
    var userInfo: UserInfo?
    private let disposeBag = DisposeBag()
    private var viewModel: ProfileDetailVM = ProfileDetailVM()
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
extension ProfileDetailVC {
    private func visualize() {
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .highlighted)
        
        let buttonLeft = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
        buttonLeft.setImage(UIImage(named: "ic_arrow_left_black"), for: .normal)
        buttonLeft.contentEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        let leftBarButton = UIBarButtonItem(customView: buttonLeft)
        
        navigationItem.leftBarButtonItem = leftBarButton
        
        let btEdit: UIButton = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
        let underLineButton: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Montserrat-Regular", size: 15.0) as Any ,
            .foregroundColor: UIColor.black,
            .underlineStyle: NSUnderlineStyle.single.rawValue]
        let attributeString = NSMutableAttributedString(string: "Chỉnh sửa",
                                                             attributes: underLineButton)
        btEdit.setAttributedTitle(attributeString, for: .normal)
        let rightButton = UIBarButtonItem(customView: btEdit)
        self.navigationItem.rightBarButtonItem = rightButton
        
        btEdit.rx.tap.bind { _ in
            if btEdit.isSelected {
                btEdit.isSelected = false
                let attributeString = NSMutableAttributedString(string: "Chỉnh sửa",
                                                                     attributes: underLineButton)
                btEdit.setAttributedTitle(attributeString, for: .normal)
                self.btSelectImage.isEnabled = false
                self.tfName.isUserInteractionEnabled = false
                let p: [String: Any] = ["name": self.tfName.text ?? ""]
                var imgs: [UIImage] = []
                imgs.append(self.img.image ?? UIImage())
                self.viewModel.updateProfile(p: p, img: imgs, urlIMG: "avatar")
                
            } else {
                btEdit.isSelected = true
                let attributeString = NSMutableAttributedString(string: "Cập nhật",
                                                                     attributes: underLineButton)
                btEdit.setAttributedTitle(attributeString, for: .normal)
                self.tfName.isUserInteractionEnabled = true
                self.tfName.becomeFirstResponder()
                self.btSelectImage.isEnabled = true
            }
            
        }.disposed(by: disposeBag)
        
        
        buttonLeft.rx.tap.bind { _ in
            self.navigationController?.popViewController()
        }.disposed(by: disposeBag)
        
        title = "Thông tin cá nhân"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                                        NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 19.0) ?? UIImage() ]
        guard let user = self.userInfo else {
            return
        }
        self.updateUI(user: user)
        btSelectImage.isEnabled = false
    }
    private func setupRX() {
        
        self.viewModel.indicator.asObservable().bind(onNext: { (item) in
            item ? LoadingManager.instance.show() : LoadingManager.instance.dismiss()
        }).disposed(by: disposeBag)
        
        if let list = RealmManager.shared.getListLocation(), list.count > 0 {
            self.getZoneDetail(list: list)
        } else {
            self.viewModel.getLocaion()
        }
        
        self.viewModel.location.asObservable().bind(onNext: weakify({ (list, wSelf) in
            wSelf.getZoneDetail(list: list)
        })).disposed(by: disposeBag)
        
        self.viewModel.err.asObservable().bind(onNext: weakify({ (err, wSelf) in
            wSelf.showAlert(title: "Thông báo", message: "\(err.message ?? "")")
        })).disposed(by: disposeBag)
        
        self.viewModel.$user.asObservable().bind(onNext: weakify({ (user, wSelf) in
            wSelf.updateUI(user: user)
        })).disposed(by: disposeBag)

    }
    private func updateUI(user: UserInfo) {
        tfName.text = user.name
        tfPhone.text = user.phone
        tfEmail.text = user.email
        tfAddress.text = user.address
        tfBirthday.text = user.birthday
        lbName.text = user.name
        lbLevel.text = "Cấp độ: \(user.level ?? 0)"
        lbGoal.text = "Điểm tích luỹ: \(user.points ?? 0) điểm"
        if let text = user.avatarURL, let url = URL(string: text) {
            img.kf.setImage(with: url)
        }
    }
    private func getZoneDetail(list: [Location]) {
        let zone = list.filter { $0.id == userInfo?.provinceID }.first
        
        guard let district = zone?.districts?.filter({ $0.id == userInfo?.districtID }).first else {
            tvZone.text = "\(zone?.province ?? "")"
            return
        }
        
        guard let ward = district.wards?.filter({ $0.id == userInfo?.wardID }).first else {
            tvZone.text = "\(zone?.province ?? "")  \(district.district ?? "")"
            return
        }
        
        tvZone.text = "\(ward.ward ?? ""), \(district.district ?? ""), \(zone?.province ?? "")"
        tvZone.sizeToFit()
        tvZone.frame.size.width = tvZone.intrinsicContentSize.width
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v: UIView = UIView()
        v.clipsToBounds = true
        v.layer.borderWidth = 1
        v.layer.borderColor = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
        
        img.backgroundColor = .red
        img.clipsToBounds = true
        img.layer.cornerRadius = 50
        v.addSubview(img)
        img.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(30)
            make.left.equalToSuperview().inset(30)
            make.width.height.equalTo(100)
        }
                
        lbLevel.textColor = .black
        lbLevel.font = UIFont(name: "Montserrat-Regular", size: 15.0)
        v.addSubview(lbLevel)
        
        lbLevel.snp.makeConstraints { (make) in
            make.centerY.equalTo(img)
            make.left.equalTo(img.snp.right).inset(-15)
            make.right.equalToSuperview().inset(15)
        }
        
        
        lbName.textColor = .black
        lbName.font = UIFont(name: "Montserrat-Regular", size: 15.0)
        v.addSubview(lbName)
        
        lbName.snp.makeConstraints { (make) in
            make.bottom.equalTo(lbLevel.snp.top).inset(-5)
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
        
        
        btSelectImage.backgroundColor = .clear
        v.addSubview(btSelectImage)
        btSelectImage.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(30)
            make.left.equalToSuperview().inset(30)
            make.width.height.equalTo(100)
        }
        
        btSelectImage.rx.tap.bind { _ in
            let img: UIImagePickerController = UIImagePickerController()
            img.delegate = self
            img.modalPresentationStyle = .overCurrentContext
            img.sourceType = .photoLibrary
            img.allowsEditing = true
            self.present(img, animated: true, completion: {
                img.navigationBar.topItem?.leftBarButtonItem?.tintColor = .black
            })
        }.disposed(by: disposeBag)
        
        return v
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 160
    }
}
extension ProfileDetailVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let tempImage:UIImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
              let count = tempImage.jpegData(compressionQuality: 1)?.count
              else {
            return
        }
        guard let imgUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL else {
            print("Không có image url")
            return
        }
        switch count {
        case 0...5000:
            tempImage.jpegData(compressionQuality: 1)
        case 5000...10000:
            tempImage.jpegData(compressionQuality: 0.5)
        case 10000...15000:
            tempImage.jpegData(compressionQuality: 0.3)
        default:
            tempImage.jpegData(compressionQuality: 0.01)
        }
        self.dismiss(animated: true) {
            self.img.image = tempImage
        }
    }
    
}
