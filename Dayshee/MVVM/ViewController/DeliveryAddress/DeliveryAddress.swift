//
//  DeliveryAddress.swift
//  Dayshee
//
//  Created by haiphan on 11/14/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import Eureka
import RxCocoa
import RxSwift
import FirebaseMessaging
import RealmSwift

enum TypeAddress {
    case addNewCart
    case addNewList
    case updateAddress
}

protocol UpdateAddressDelegate {
    func updateAddress(item: AddressModel)
    func addNewAddressCart(item: AddressModel)
}
class DeliveryAddress: FormViewController {
    
    var delegate: UpdateAddressDelegate?
    var typeAddress: TypeAddress = .addNewCart
    private let btConfirm: HighlightedButton = HighlightedButton(frame: .zero)
    private var dataSource: [Location] = []
    private let viewModel: DeliveryAddressVM = DeliveryAddressVM()
    private var locationID: BehaviorRelay<Int?> = BehaviorRelay.init(value: nil)
    private var districtID: BehaviorRelay<Int?> = BehaviorRelay.init(value: nil)
    private var wardID: BehaviorRelay<Int?> = BehaviorRelay.init(value: nil)
    private let sectionDisplay: BehaviorRelay<Void> = BehaviorRelay.init(value: ())
    private let displayUserInfo: BehaviorRelay<Void> = BehaviorRelay.init(value: ())
    private var isSetDefault: Bool = false
    var user: AddressModel?
    var tempUser: RegisterTemp = RegisterTemp()
    private var isValid: Bool = false
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
extension DeliveryAddress {
    private func visualize() {
        self.view.backgroundColor = .white
        let buttonLeft = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
        buttonLeft.setImage(UIImage(named: "ic_arrow_left_black"), for: .normal)
        buttonLeft.contentEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        let leftBarButton = UIBarButtonItem(customView: buttonLeft)
        
        navigationItem.leftBarButtonItem = leftBarButton
        buttonLeft.rx.tap.bind { _ in
            self.navigationController?.popViewController()
        }.disposed(by: disposeBag)
        
        title = "Nhập địa chỉ giao hàng"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                                        NSAttributedString.Key.font: UIFont(name: "Montserrat-Medium", size: 15.0) ?? UIImage() ]
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        
        btConfirm.setTitle("Cập nhật", for: .normal)
        btConfirm.titleLabel?.font = UIFont(name: "Montserrat-Medium", size: 15.0)
        btConfirm.backgroundColor = UIColor(named: "ColorApp")
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
        
    }
    private func setupRX() {
        self.viewModel.indicator.asObservable().bind(onNext: { (item) in
            item ? LoadingManager.instance.show() : LoadingManager.instance.dismiss()
        }).disposed(by: disposeBag)
        
        if let list = RealmManager.shared.getListLocation(), list.count > 0 {
            self.dataSource = list
        } else {
            self.viewModel.getLocaion()
        }
        
        self.viewModel.location.asObservable().bind(onNext: weakify({ (data, wSelf) in
            wSelf.dataSource = data
            guard let row = self.form.rowBy(tag: "Zone") as? RowDetailGeneric<RowCellRegisterCity> else  {
                return
            }
            row.cell.dataSource.accept(data)
        })).disposed(by: disposeBag)
        
        setupForm()
        
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
                wSelf.districtID.accept(nil)
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
                wSelf.user?.districtID = district.id
                wSelf.user?.wardID = ward.id
                wSelf.user?.provinceID = location.id
                 
                wSelf.tempUser.district = district.id
                wSelf.tempUser.ward = ward.id
                wSelf.tempUser.zone = location.id
            }.disposed(by: disposeBag)
        
        self.btConfirm.rx.tap.bind(onNext: weakify({ (wSelf) in
            guard wSelf.isValid else {
                wSelf.showAlert(title: "Thông báo", message: "Vui lòng điền đầy đủ thông tin")
                return
            }
            guard wSelf.typeAddress == .updateAddress else {
                wSelf.addAddressTypeCart()
                return
            }
            wSelf.addAddressTypeList()
        })).disposed(by: disposeBag)
        
        self.displayUserInfo.asObservable().bind(onNext: weakify({ (wSelf) in
            guard let locationID = wSelf.tempUser.zone,
                  let dicstrictID = wSelf.tempUser.district, let wardID = wSelf.tempUser.ward  else {
                return
            }
            wSelf.bindToData(locationID: locationID, dicstrictID: dicstrictID, wardID: wardID)
        })).disposed(by: disposeBag)
        
        self.sectionDisplay.asObservable().bind { [weak self] _ in
            guard let wSelf = self,
                  let locationID = wSelf.user?.provinceID,
                  let dicstrictID = wSelf.user?.districtID, let wardID = wSelf.user?.wardID  else {
                return
            }
            wSelf.bindToData(locationID: locationID, dicstrictID: dicstrictID, wardID: wardID)
        }.disposed(by: disposeBag)
        
        self.viewModel.$address.asObservable().bind { item in
            guard self.typeAddress == .updateAddress else {
                self.delegate?.addNewAddressCart(item: item)
                return
            }
            self.delegate?.updateAddress(item: item)
        }.disposed(by: disposeBag)
        
        self.viewModel.err.asObservable().bind(onNext: weakify({ (err, wSelf) in
            wSelf.showAlert(title: nil, message: err.message)
        })).disposed(by: disposeBag)
    }
    private func bindToData(locationID: Int, dicstrictID: Int, wardID: Int) {
        guard let listDistrict = self.dataSource.filter({ $0.id == locationID }).first?.districts else {
            return
        }
        guard let row = self.form.rowBy(tag: "District") as? RowDetailGeneric<RowCellRegisterDistrict> else  {
            return
        }
        guard let listWard = listDistrict.filter({ $0.id == dicstrictID }).first?.wards else {
            return
        }
        guard let district = listDistrict.filter({ return $0.id == dicstrictID }).first else {
            return
        }
        guard let ward = listWard.filter({ return $0.id == wardID }).first else {
            return
        }
        guard let rowZone = self.form.rowBy(tag: "Zone") as? RowDetailGeneric<RowCellRegisterCity> else  {
            return
        }
        rowZone.value = locationID
        self.validate(row: rowZone)
        row.cell.currentDistrict = district
        row.cell.currentWard = ward
        row.cell.listDistrict.accept(listDistrict)
        row.cell.listWard.accept(listWard)
    }
    private func addAddressTypeCart() {
        guard let name = self.tempUser.name,
              let phone = self.tempUser.phone,
              let address = self.tempUser.address,
              let province = self.tempUser.zone,
              let district = self.tempUser.district,
              let ward = self.tempUser.ward else {
            return
        }
        guard self.isValidPhone(phone: phone) else {
            self.showAlert(title: nil, message: "Vui lòng nhập đúng định dạng Số điện thoại")
            return
        }
        let p: [String: Any] = [
            "name": name, "phone": phone, "address": address, "province_id": province, "district_id": district,
            "ward_id": ward, "is_default": self.isSetDefault
        ]
        self.viewModel.addAddress(p: p)
    }
    private func addAddressTypeList() {
        guard let name = self.user?.name,
              let phone = self.user?.phone,
              let address = self.user?.address,
              let province = self.user?.provinceID,
              let district = self.user?.districtID,
              let ward = self.user?.wardID,
              let id = self.user?.id  else {
            return
        }
        guard self.isValidPhone(phone: phone) else {
            self.showAlert(title: nil, message: "Vui lòng nhập đúng định dạng Số điện thoại")
            return
        }
        let p: [String: Any] = [
            "name": name, "phone": phone, "address": address, "province_id": province, "district_id": district,
            "ward_id": ward, "is_default": self.isSetDefault, "id": id
        ]
        self.viewModel.updateAddress(p: p)
    }
    private func setupSection() -> Section {
        let section = Section()
        
        section <<< RowDetailGeneric<FinalCellRegister>.init("FullName", { (row) in
            row.cell.updateUI(title: "Họ tên", placeHolder: "Nhập họ tên")
            row.cell.setupDisplay(item: self.user?.name ?? self.tempUser.name)
            row.add(rule: RuleRequired())
            row.onRowValidationChanged { [weak self] _, row in
                self?.validate(row: row)
            }
            row.cell.tfSub.rx.text.bind { [weak self] value in
                self?.user?.name = value
                self?.tempUser.name = value
            }.disposed(by: disposeBag)
        })
        
        section <<< RowDetailGeneric<FinalCellRegister>.init("NumberPhone", { (row) in
            row.cell.updateUI(title: "Số điện thoại", placeHolder: "Nhập số điện thoại")
            row.cell.setupDisplay(item: self.user?.phone ?? self.tempUser.phone)
            row.cell.tfSub.keyboardType = .numberPad
            row.add(rule: RuleRequired())
            row.onRowValidationChanged { [weak self] _, row in
                self?.validate(row: row)
            }
            
            row.cell.tfSub.rx.text.bind { [weak self] value in
                self?.user?.phone = value
                self?.tempUser.phone = value
            }.disposed(by: disposeBag)
        })
        
        section <<< RowDetailGeneric<FinalCellRegister>.init("Address", { (row) in
            row.cell.updateUI(title: "Địa chỉ", placeHolder: "Nhập địa chỉ")
            row.cell.setupDisplay(item: self.user?.address ?? self.tempUser.address)
            row.add(rule: RuleRequired())
            row.onRowValidationChanged { [weak self] _, row in
                self?.validate(row: row)
            }
            row.cell.tfSub.rx.text.bind { [weak self] value in
                self?.user?.address = value
                self?.tempUser.address = value
            }.disposed(by: disposeBag)
        })
        section <<< RowDetailGeneric<RowCellRegisterCity>.init("Zone", { (row) in
            row.tag = "Zone"
            row.cell.updateUI(title: "Tỉnh/Thành Phố", placeHolder: "Nhập địa chỉ")
            let item = self.dataSource.filter { (l) -> Bool in
                return l.id == (self.user?.provinceID ?? self.tempUser.zone)
            }
            row.value = item.first?.id
            row.cell.tfSub.text = item.first?.province
            self.user?.provinceID = item.first?.id
            row.add(rule: RuleRequired())
            row.onRowValidationChanged { [weak self] _, row in
                self?.validate(row: row)
                
            }
            row.cell.locationID.asObservable().bind(onNext: weakify({ (id, wSelf) in
                wSelf.locationID.accept(id)
            })).disposed(by: disposeBag)
        })
        
        section <<< RowDetailGeneric<RowCellRegisterDistrict>.init("District", { (row) in
            row.tag = "District"
            row.add(rule: RuleRowValid(isValid: true))
            row.onRowValidationChanged { [weak self] _, row in
                self?.validate(row: row)
            }
            row.cell.districtID.asObservable().bind(onNext: weakify({ (id, wSelf) in
                wSelf.districtID.accept(id)
            })).disposed(by: disposeBag)
            
            row.cell.wardID.asObservable().bind(onNext: weakify({ (id, wSelf) in
                wSelf.wardID.accept(id)
            })).disposed(by: disposeBag)
            
            let item = self.dataSource.filter { (l) -> Bool in
                return l.id == (self.user?.provinceID ?? self.tempUser.zone)
            }.first
            
            let district = item?.districts?.filter({ (d) -> Bool in
                return d.id == (self.user?.districtID ?? self.tempUser.district)
            }).first
            row.cell.tfSub.text = district?.district
            
            let ward = district?.wards?.filter({ (w) -> Bool in
                return w.id == (self.user?.wardID ?? self.tempUser.ward)
            }).first
            row.cell.tfWard.text = ward?.ward
        })
        
        section <<< RowDetailGeneric<DefaultView>.init("Default", { (row) in
            row.cell.isSetDefault = { [weak self] isSet in
                self?.isSetDefault = isSet
            }
            row.cell.setupDisplay(item: self.user?.isDefault ?? false)
        })
        
        self.sectionDisplay.accept(())
        self.displayUserInfo.accept(())
        return section
    }
    private func validate(row: BaseRow?) {
        self.isValid = self.form.validate().isEmpty
    }
    private func setupForm() {
        self.form += [self.setupSection()]
        
        guard let row = self.form.rowBy(tag: "Zone") as? RowDetailGeneric<RowCellRegisterCity> else  {
            return
        }
        row.cell.dataSource.accept(self.dataSource)
    }
    private func updateStateWard(row: RowDetailGeneric<RowCellRegisterDistrict>) {
        row.cell.tfWard.text = nil
        row.cell.tfWard.placeholder = "Chọn"
        row.value = false
        row.validate()
    }
}

