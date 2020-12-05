//
//  RegisterVC.swift
//  Dayshee
//
//  Created by haiphan on 10/31/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import Eureka
import RxCocoa
import RxSwift
import FirebaseMessaging
import RealmSwift


class RegisterVC: FormViewController {
    
    var phone: String?
    var password: String?
    private let btConfirm: UIButton = UIButton(frame: .zero)
    private var isValid: Bool = false
    private var modeTemp: RegisterTemp = RegisterTemp()
    private let viewModel: RegisterVM = RegisterVM()
    private var locationID: PublishSubject<Int> = PublishSubject.init()
    private var districtID: PublishSubject<Int?> = PublishSubject.init()
    private var wardID: PublishSubject<Int?> = PublishSubject.init()
    private var dataSource: [Location] = []
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
extension RegisterVC {
    private func visualize() {
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .highlighted)
        
        let buttonLeft = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
        buttonLeft.setImage(UIImage(named: "ic_arrow_left_black"), for: .normal)
        buttonLeft.contentEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        let leftBarButton = UIBarButtonItem(customView: buttonLeft)
        
        let btTitle: UIButton = UIButton()
        btTitle.setTitle("Đăng kí", for: .normal)
        btTitle.isUserInteractionEnabled = false
        btTitle.setTitleColor(.black, for: .normal)
        let leftBarButtonTitle = UIBarButtonItem(customView: btTitle)
        
        navigationItem.leftBarButtonItems = [leftBarButton, leftBarButtonTitle]
        buttonLeft.rx.tap.bind { _ in
            self.navigationController?.popViewController()
        }.disposed(by: disposeBag)
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        
        btConfirm.setTitle("Đăng kí", for: .normal)
        btConfirm.backgroundColor = #colorLiteral(red: 0.007841385901, green: 0.007844363339, blue: 0.007840993814, alpha: 1)
        btConfirm.setTitleColor(.white, for: .normal)
        btConfirm.clipsToBounds = true
        btConfirm.layer.cornerRadius = 5
        self.view.addSubview(btConfirm)
        btConfirm.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(55)
            make.bottom.equalToSuperview().inset(42)
            make.height.equalTo(50)
        }
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(btConfirm.snp.top).inset(-10)
        }
        self.form += [self.setupSection()]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                                        NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 19.0) ?? UIImage() ]
    }
    private func setupRX() {
        
        self.viewModel.indicator.asObservable().bind(onNext: { (item) in
            item ? LoadingManager.instance.show() : LoadingManager.instance.dismiss()
        }).disposed(by: disposeBag)
        
        if let list = RealmManager.shared.getListLocation(), list.count > 0 {
            self.dataSource = list
            guard let row = self.form.rowBy(tag: "Zone") as? RowDetailGeneric<RowCellRegisterCity> else  {
                return
            }
            row.cell.dataSource.accept(list)
        } else {
            self.viewModel.getLocaion()
        }
        
        self.viewModel.location
            .asObservable()
            .bind(onNext: weakify({ (data, wSelf) in
                wSelf.dataSource = data
                guard let row = self.form.rowBy(tag: "Zone") as? RowDetailGeneric<RowCellRegisterCity> else  {
                    return
                }
                row.cell.dataSource.accept(data)
            })).disposed(by: disposeBag)
        
        self.btConfirm.rx.tap
            .bind(onNext: weakify({ (wSelf) in
                guard wSelf.isValid else {
                    wSelf.showAlert(title: "Thông báo", message: "Vui lòng điền đầy đủ thông tin")
                    return
                }
                guard let zone = wSelf.modeTemp.zone,
                      let district = self.modeTemp.district,
                      let ward = self.modeTemp.ward,
                      let birth = self.modeTemp.birthday,
                      let phone = self.modeTemp.phone,
                      let pass = self.password
                else {
                    return
                }
                let p: [String : Any] = [
                    "phone": phone,
                    "password": pass,
                    "name": self.modeTemp.name ?? "",
                    "address": self.modeTemp.address ?? "",
                    "province_id": zone,
                    "district_id": district,
                    "ward_id": ward,
                    "birthday": birth,
                    "device_token" : Messaging.messaging().fcmToken ?? "",
                    "mac_address": UIDevice.current.identifierForVendor?.uuidString ?? ""
                ]
                guard let row = wSelf.form.rowBy(tag: "Avatar") as? RowDetailGeneric<RowCellRegisterAvatar>,
                      let img = row.cell.imgCircle.image else  {
                    return
                }
                wSelf.viewModel.uploadImage(p: p, img: img, urlIMG: "avatar")
            })).disposed(by: disposeBag)
        
        self.locationID.distinctUntilChanged().asObservable()
            .bind(onNext: weakify({ [weak self] (id, wSelf) in
                guard let wSelf = self else {
                    return
                }
                guard let listDistrict = wSelf.dataSource.filter({ $0.id == id }).first?.districts else {
                    return
                }
                guard let row = wSelf.form.rowBy(tag: "District") as? RowDetailGeneric<RowCellRegisterDistrict> else  {
                    return
                }
                row.cell.listWard.accept([])
                wSelf.districtID.onNext(nil)
                row.cell.currentDistrict = nil
                row.cell.tfSub.text = nil
                row.cell.tfSub.placeholder = "Chọn"
                wSelf.updateStateWard(row: row)
                row.cell.listDistrict.accept(listDistrict)
            })).disposed(by: disposeBag)
        
        Observable.combineLatest(self.locationID.asObservable().distinctUntilChanged(),
                                 self.districtID.asObservable().distinctUntilChanged())
            .bind { [weak self] (idLocation, idDistrict) in
                guard let wSelf = self else {
                    return
                }
                guard let listDistrict = wSelf.dataSource.filter({ $0.id == idLocation }).first?.districts else {
                    return
                }
                guard let idDistrict = idDistrict else {
                    return
                }
                guard let listWard = listDistrict.filter({ $0.id == idDistrict }).first?.wards else {
                    return
                }
                guard let row = wSelf.form.rowBy(tag: "District") as? RowDetailGeneric<RowCellRegisterDistrict> else  {
                    return
                }
                row.cell.currentWard = nil
                row.cell.wardID.onNext(nil)
                wSelf.updateStateWard(row: row)
                row.cell.listWard.accept(listWard)
            }.disposed(by: disposeBag)
        
        Observable
            .combineLatest(self.locationID.distinctUntilChanged(),
                           self.districtID.distinctUntilChanged(),
                           self.wardID.distinctUntilChanged())
            .bind { [weak self] (idLocation, idDistrict, idWard) in
                guard let wSelf = self else {
                    return
                }
                guard let location = wSelf.dataSource.filter({ $0.id == idLocation }).first else {
                    return
                }
                
                guard let idDistrict = idDistrict else {
                    return
                }
                
                guard let district = location.districts?.filter({ $0.id == idDistrict }).first else {
                    return
                }
                guard let idWard = idWard else {
                    return
                }
                guard let ward = district.wards?.filter({ $0.id == idWard }).first else {
                    return
                }
                wSelf.modeTemp.district = district.id
                wSelf.modeTemp.ward = ward.id
                wSelf.modeTemp.zone = location.id
            }.disposed(by: disposeBag)
        
        self.viewModel.data.asObservable()
            .bind(onNext: weakify({ (data, wSelf) in
                let vc = BaseTabbarViewController()
                vc.hidesBottomBarWhenPushed = true
                vc.selectedIndex = 5
                wSelf.navigationController?.pushViewController(vc, animated: true)
            })).disposed(by: disposeBag)
        
        self.viewModel.err.asObserver().bind(onNext: weakify({ (err, wSelf) in
            wSelf.showAlert(title: nil, message: err.message)
        })).disposed(by: disposeBag)
        
    }
    
    private func setupSection() -> Section {
        let section = Section()
        section <<< RowDetailGeneric<RowCellRegisterAvatar>.init("Avatar", { (row) in
            row.cell.updateUI(title: "Tải ảnh đại diện", imageCircle: "ic_circle_register", imageAvatar: "ic_camera")
            row.cell.presentImage = {
                let img: UIImagePickerController = UIImagePickerController()
                img.delegate = self
                img.modalPresentationStyle = .custom
                img.sourceType = .photoLibrary
                img.allowsEditing = true
                
                self.present(img, animated: true, completion: nil)
            }
            row.onRowValidationChanged { [weak self] _, row in
                self?.validate(row: row)
            }
        })
        
        section <<< RowDetailGeneric<FinalCellRegister>.init("FullName", { (row) in
            row.cell.updateUI(title: "Họ tên", placeHolder: "Nhập họ tên")
            row.add(rule: RuleRequired())
            row.onRowValidationChanged { [weak self] _, row in
                self?.validate(row: row)
            }
            row.cell.tfSub.rx.text.bind { [weak self] value in
                self?.modeTemp.name = value
            }.disposed(by: disposeBag)
        })
        
        section <<< RowDetailGeneric<FinalCellRegister>.init("NumberPhone", { (row) in
            row.cell.updateUI(title: "Số điện thoại", placeHolder: "Nhập số điện thoại")
            row.cell.setupDisplay(item: self.phone)
            row.cell.tfSub.isUserInteractionEnabled = false
            row.add(rule: RuleRequired())
            row.onRowValidationChanged { [weak self] _, row in
                self?.validate(row: row)
            }
            row.cell.tfSub.rx.text.bind { [weak self] value in
                self?.modeTemp.phone = value
            }.disposed(by: disposeBag)
        })
        
        section <<< RowDetailGeneric<FinalCellRegister>.init("Address", { (row) in
            row.cell.updateUI(title: "Địa chỉ", placeHolder: "Nhập địa chỉ")
            row.add(rule: RuleRequired())
            row.onRowValidationChanged { [weak self] _, row in
                self?.validate(row: row)
            }
            row.cell.tfSub.rx.text.bind { [weak self] value in
                self?.modeTemp.address = value
            }.disposed(by: disposeBag)
        })
        section <<< RowDetailGeneric<RowCellRegisterCity>.init("Zone", { (row) in
            row.tag = "Zone"
            row.cell.updateUI(title: "Tỉnh/Thành Phố", placeHolder: "Nhập địa chỉ")
            row.add(rule: RuleRequired())
            row.onRowValidationChanged { [weak self] _, row in
                self?.validate(row: row)
                
            }
            row.cell.locationID.asObservable().bind(onNext: weakify({ (id, wSelf) in
                wSelf.locationID.onNext(id)
            })).disposed(by: disposeBag)
        })
        
        section <<< RowDetailGeneric<RowCellRegisterDistrict>.init("District", { (row) in
            row.tag = "District"
            row.add(rule: RuleRowValid(isValid: true))
            row.onRowValidationChanged { [weak self] _, row in
                self?.validate(row: row)
            }
            row.cell.districtID.asObservable().bind(onNext: weakify({ (id, wSelf) in
                wSelf.districtID.onNext(id)
            })).disposed(by: disposeBag)
            
            row.cell.wardID.asObservable().bind(onNext: weakify({ (id, wSelf) in
                wSelf.wardID.onNext(id)
            })).disposed(by: disposeBag)
        })
        
        section <<< RowDetailGeneric<RowCellRegisterBirthday>.init("Birthday", { (row) in
            row.add(rule: RuleRequired())
            row.onRowValidationChanged { [weak self] _, row in
                self?.validate(row: row)
            }
            row.cell.tfSub.rx.text.bind { [weak self] value in
                self?.modeTemp.birthday = value
            }.disposed(by: disposeBag)
        })
        return section
    }
    private func updateStateWard(row: RowDetailGeneric<RowCellRegisterDistrict>) {
        row.cell.tfWard.text = nil
        row.cell.tfWard.placeholder = "Chọn"
        row.value = false
        row.validate()
    }
    private func validate(row: BaseRow?) {
        self.isValid = self.form.validate().isEmpty
    }
    private func getUrlImage(imgUrl: URL, info: [UIImagePickerController.InfoKey : Any]) -> String {
        let imgName = imgUrl.lastPathComponent
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let localPath = documentDirectory?.appending(imgName)
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let data = image.pngData()! as NSData
        data.write(toFile: localPath!, atomically: true)
        let photoURL = URL.init(fileURLWithPath: localPath!)//NSURL(fileURLWithPath: localPath!)
        return photoURL.absoluteString
    }
}
extension RegisterVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let tempImage:UIImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
              let count = tempImage.jpegData(compressionQuality: 1)?.count
        else {
            return
        }
        guard let row = self.form.rowBy(tag: "Avatar") as? RowDetailGeneric<RowCellRegisterAvatar> else  {
            return
        }
        guard let imgUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL else {
            print("Không có image url")
            return
        }
        row.value = true
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
        
        row.cell.imgCircle.image = tempImage
        row.cell.imgAvatar.isHidden = true
        
        self.modeTemp.dataImages = info
        self.modeTemp.url = self.getUrlImage(imgUrl: imgUrl, info: info)
        row.validate()
        self.dismiss(animated: true) {
            if row.value == false {
                self.showAlert(title: "Thông báo", message: "Dung lượng tấm hình quá lớn ")
                row.cell.imgCircle.image = UIImage(named: "ic_circle_register")
                row.cell.imgAvatar.isHidden = false
            }
        }
    }
    
}
