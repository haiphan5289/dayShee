//
//  FormOfDeliveryVC.swift
//  Dayshee
//
//  Created by paxcreation on 11/13/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import DZNEmptyDataSet
import ViewAnimator

enum TypeAddressView {
    case update
    case change
}

class FormOfDeliveryVC: UIViewController {

    @IBOutlet weak var btOrder: UIButton!
    var listOrder: [HomeDetailModel] = []
    var total: Double = 0
    var promotionCode: String?
    var addressInfo: AddressModel?
    var type: TypeAddressView = .update
    var cardDetail: CartModelDetail?
    private let viewModel: FormOfDeliveryVM = FormOfDeliveryVM()
    private let tableView: UITableView = UITableView(frame: .zero, style: .grouped)
    private let tap: UITapGestureRecognizer = UITapGestureRecognizer()
    private var hKeyboard: CGFloat = 0
    private var shipMode: DeliveryMode?
    private var listDelivery: [DeliveryMode] = []
    private let disposeBag = DisposeBag()
    private var textNote: String = ""
    private var textUserCode: String = ""
    private var rowTotal = 4
    override func viewDidLoad() {
        super.viewDidLoad()
        visualize()
        setupRX()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.viewModel.moveToListAddress = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
extension FormOfDeliveryVC {
    private func visualize() {
        let buttonLeft = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
        buttonLeft.setImage(UIImage(named: "ic_arrow_left_black"), for: .normal)
        buttonLeft.contentEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        let leftBarButton = UIBarButtonItem(customView: buttonLeft)

        navigationItem.leftBarButtonItem = leftBarButton
        buttonLeft.rx.tap.bind { _ in
            self.navigationController?.popViewController()
        }.disposed(by: disposeBag)

        title = "Hình thức giao hàng"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                                        NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 19.0) as Any]
                
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.allowsSelection = false
        self.view.addSubview(self.tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(btOrder.snp.top).inset(-10)
            make.top.equalTo(self.view.safeAreaInsets).inset(4)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.register(HomeCellGeneric<TotalPriceView>.self, forCellReuseIdentifier: TotalPriceView.identifier)
        tableView.register(HomeCellGeneric<OrderView>.self, forCellReuseIdentifier: OrderView.identifier)
        tableView.register(HomeCellGeneric<DeliveryView>.self, forCellReuseIdentifier: DeliveryView.identifier)
        tableView.register(HomeCellGeneric<DeliveryAddressView>.self, forCellReuseIdentifier: DeliveryAddressView.identifier)
        tableView.register(HomeCellGeneric<NoteView>.self, forCellReuseIdentifier: NoteView.identifier)
        tableView.register(HomeCellGeneric<ReferralCodeView>.self, forCellReuseIdentifier: ReferralCodeView.identifier)
        
        let vLine: UIView = UIView(frame: .zero)
        vLine.backgroundColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
        self.view.addSubview(vLine)
        vLine.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
        tap.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(tap)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                                        NSAttributedString.Key.font: UIFont(name: "Montserrat-Medium", size: 15.0) ?? UIImage() ]
    }
    private func setupRX() {
        self.viewModel.setupRX()
        
        self.viewModel.$isLogin.asObservable().bind(onNext: weakify({ (isLogin, wSelf) in
            guard !isLogin else {
                return
            }
            let vc = self
            vc.hidesBottomBarWhenPushed = false
            let login = STORYBOARD_AUTH.instantiateViewController(withIdentifier: LoginVC.className) as! LoginVC
            login.hidesBottomBarWhenPushed = false
            login.typeLogin = .rate
            login.delegateRate = self
            self.navigationController?.pushViewController(login, animated: true)
        })).disposed(by: disposeBag)
        
        self.viewModel.$moveToDeliveryAddress.asObservable().bind(onNext: weakify({ (_, wSelf) in
            let vc = DeliveryAddress()
            vc.hidesBottomBarWhenPushed = true
            vc.delegate = self
            vc.tempUser = wSelf.viewModel.getUserInfo()
            wSelf.navigationController?.pushViewController(vc, animated: true)
        })).disposed(by: disposeBag)
        
        self.viewModel.indicator.asObservable().bind(onNext: { (item) in
            item ? LoadingManager.instance.show() : LoadingManager.instance.dismiss()
        }).disposed(by: disposeBag)
        
        self.viewModel.$err.asObservable().bind(onNext: weakify({ (err, wSelf) in
            wSelf.showAlert(title: nil, message: err.message)
        })).disposed(by: disposeBag)
        
        self.viewModel.$shipMode.asObservable().bind(onNext: weakify({ (d, wSelf) in
            wSelf.shipMode = d
//            let index = IndexPath(row: wSelf.rowTotal, section: 0)
//            guard let cellTotal = wSelf.tableView.cellForRow(at: index) as? HomeCellGeneric<TotalPriceView> else {
//                return
//            }
//            cellTotal.view.setupDiscount(total: self.total, promotionCode: self.promotionCode, feeShip: d.price ?? 0)
        })).disposed(by: disposeBag)
        
        self.viewModel.$listDelivery.asObservable().bind(onNext: weakify({ (list, wSelf) in
            wSelf.listDelivery = list
            
            guard let first = list.first else {
                return
            }
//            let index = IndexPath(row: wSelf.rowTotal, section: 0)
//            guard let cellTotal = wSelf.tableView.cellForRow(at: index) as? HomeCellGeneric<TotalPriceView> else {
//                return
//            }
            wSelf.shipMode = first
            wSelf.tableView.reloadData()
//            cellTotal.view.setupDiscount(total: self.total, promotionCode: self.promotionCode, feeShip: first.price ?? 0)
//            wSelf.tableView.reloadData()
        })).disposed(by: disposeBag)
        
        self.viewModel.$listAddress.asObservable().bind(onNext: weakify({ (list, wSelf) in
            let index = IndexPath(row: 0, section: 0)
            guard let cell = wSelf.tableView.cellForRow(at: index) as? HomeCellGeneric<DeliveryAddressView> else {
                return
            }
//            let indexTotal = IndexPath(row: wSelf.rowTotal, section: 0)
//            guard let cellTotal = wSelf.tableView.cellForRow(at: indexTotal) as? HomeCellGeneric<TotalPriceView> else {
//                return
//            }
//            cellTotal.view.setupDiscount(total: self.total, promotionCode: self.promotionCode, feeShip: 0)
            guard let count = list.data?.count, count > 0 else {
                cell.view.setupDisplayView(item: (.update, nil))
                wSelf.tableView.beginUpdates()
                wSelf.tableView.endUpdates()
                wSelf.viewModel.moveToDeliveryAddress = ()
                return
            }
            guard let list = list.data, let first = list.first else {
                return
            }
            wSelf.addressInfo = first
            cell.view.setupDisplayView(item: (.change, first))
            wSelf.tableView.beginUpdates()
            wSelf.tableView.endUpdates()
        })).disposed(by: disposeBag)
        
        Observable.combineLatest(self.viewModel.$listAddress, self.viewModel.$moveToListAddress)
            .asObservable()
            .bind { [weak self] (list, isMove) in
                guard let wSelf = self, isMove else {
                    return
                }
                guard let l = list.data, let f = l.first else {
                    return
                }
                let vc = ListAddressDeliveryVC(nibName: "ListAddressDeliveryVC", bundle: nil)
                vc.hidesBottomBarWhenPushed = true
                vc.currentSelect = wSelf.addressInfo ?? f
                vc.delegate = self
                wSelf.navigationController?.pushViewController(vc, animated: true)
            }.disposed(by: disposeBag)
                
        self.btOrder.rx.tap.bind(onNext: weakify({ (wSelf) in
            guard (wSelf.addressInfo != nil) else {
                wSelf.showAlert(title: nil, message: "Vui lòng chọn địa chỉ cần giao")
                return
            }
            var p: [String: Any] = ["name": self.addressInfo?.name ?? "",
                                    "phone": self.addressInfo?.phone ?? "",
                                    "address": self.addressInfo?.address ?? "",
                                    "province_id": self.addressInfo?.province?.id ?? 0,
                                    "district_id": self.addressInfo?.district?.id ?? 0,
                                    "ward_id": self.addressInfo?.ward?.id ?? 0,
                                    "delivery_id": self.shipMode?.id ?? 0,
                                    "gift_code": self.promotionCode ?? "",
                                    "note": self.textNote,
                                    "user_code": self.textUserCode
            ]
            var listProduct: [(Int, Int)] = []
            self.listOrder.forEach { (o) in
                guard let id = o.productOptionID, let count = o.count else {
                    return
                }
                let item: (Int, Int) = (id, count)
                listProduct.append(item)

            }
            let products = listProduct.compactMap { (a,b) -> (String) in
                return "{\"product_option_id\":\(a), \"quantity\":\(b)}"
            }
            p["products"] = products
            self.viewModel.postOrder(p: p)
        })).disposed(by: disposeBag)
        
        self.viewModel.$orderSuccess.asObservable().bind(onNext: weakify({ (ord, wSelf) in
            let vc = OrderSuccessVC(nibName: "OrderSuccessVC", bundle: nil)
            vc.hidesBottomBarWhenPushed = false
            vc.order = ord
            RealmManager.shared.deleteCarAll()
            wSelf.navigationController?.pushViewController(vc, animated: true)
        })).disposed(by: disposeBag)
        
        self.tap.rx.event.bind { _ in
            self.view.endEditing(true)
        }.disposed(by: disposeBag)
        
        let show = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification).map { KeyboardInfo($0) }
        let hide = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification).map { KeyboardInfo($0) }
        
        Observable.merge(show, hide).bind(onNext: weakify({ (keyboard, wSelf) in
            wSelf.runAnimate(by: keyboard)
        })).disposed(by: disposeBag)
    }
    func runAnimate(by keyboarInfor: KeyboardInfo?) {
        guard let i = keyboarInfor else {
            return
        }
        let h = (i.height > 0) ? (i.height - 97) : 10
        let d = i.duration
        
        UIView.animate(withDuration: d) {
            self.tableView.snp.updateConstraints { (make) in
                make.bottom.equalTo(self.btOrder.snp.top).inset(-h)
            }
        }
    }
}
extension FormOfDeliveryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //khi thay đổi mảng - thay đổi thêm giái trị rowTotal
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DeliveryView.identifier) as? HomeCellGeneric<DeliveryView> else {
                fatalError("Not implement")
            }
            cell.view.setupDisplay(item: self.listDelivery)
            cell.view.shipMode = { d in
                self.viewModel.shipMode = d
            }
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderView.identifier) as? HomeCellGeneric<OrderView> else {
                fatalError("Not implement")
            }
            cell.view.listOrder = self.listOrder
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteView.identifier) as? HomeCellGeneric<NoteView> else {
                fatalError("Not implement")
            }
            cell.view.textNote = { text in
                self.textNote = text
            }
            cell.view.upateHeightNoteView = {
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }
            return cell
        case 4:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReferralCodeView.identifier) as? HomeCellGeneric<ReferralCodeView> else {
                fatalError("Not implement")
            }
            cell.view.textNote = { text in
                self.textUserCode = text
            }
            cell.view.upateHeightNoteView = {
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }
            return cell
        case 5:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TotalPriceView.identifier) as? HomeCellGeneric<TotalPriceView> else {
                fatalError("Not implement")
            }
            cell.view.removeView(views: [cell.view.vPromotion])
            if let card = self.cardDetail {
                cell.view.updateUITotalPrice(cartDetail: card)
            }
            cell.view.hideButtonRemove()
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DeliveryAddressView.identifier) as? HomeCellGeneric<DeliveryAddressView> else {
                fatalError("Not implement")
            }
            cell.view.moveToDeliveryAddress = {
                self.viewModel.moveToDeliveryAddress = ()
            }
            cell.view.moveToListAddress = {
                self.viewModel.moveToListAddress = true
            }
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    
}
extension FormOfDeliveryVC: UpdateAddressDelegate {
    func addNewAddressCart(item: AddressModel) {
        self.viewModel.getListAddress()
        self.tableView.reloadData()
        self.navigationController?.popToViewController(self, animated: true)
    }
    
    func updateAddress(item: AddressModel) {
    }
    
}
extension FormOfDeliveryVC: AddressModelSelectDelegate {
    func selectItem(item: AddressModel) {
        self.addressInfo = item
        let index = IndexPath(row: 0, section: 0)
        guard let cell = self.tableView.cellForRow(at: index) as? HomeCellGeneric<DeliveryAddressView> else {
            return
        }
        cell.view.setupDisplayView(item: (.change, item))
        self.navigationController?.popToViewController(self, animated: true)
    }
}

extension FormOfDeliveryVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "Hiện tại bạn chưa có giỏ hàng"
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                   NSAttributedString.Key.font: UIFont(name: "Montserrat-Medium", size: 15)]
        let t = NSAttributedString(string: text, attributes: titleTextAttributes as [NSAttributedString.Key : Any])
        return t
    }
}
extension FormOfDeliveryVC: RateLoginDelegate {
    func callBack() {
        self.viewModel.setupRX()
        let vc = self
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.popToViewController(self, animated: true)
    }
}
