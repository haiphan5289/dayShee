//
//  CartVC.swift
//  MVVM_2020
//
//  Created by Admin on 10/28/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class CartVC: BaseHiddenNavigationController {
    
    @IBOutlet weak var btOrder: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomTableView: NSLayoutConstraint!
    private var viewModel: CartModel = CartModel()
    private var total: Double = 0
    var promotionCode: String?
    private var dataSource: [HomeDetailModel] = []
    private var cardDetail: CartModelDetail?
    private let isReloadTableView: PublishSubject<Bool> = PublishSubject.init()
    private let tap: UITapGestureRecognizer = UITapGestureRecognizer()
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        visualize()
        setupRX()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.viewModel.checkLogin()
        isReloadTableView.onNext(false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isReloadTableView.onNext(true)
    }
}
extension CartVC {
    private func visualize() {
        let img = UIImage(named: "ic_chevron_right")
        self.btOrder.imageView?.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(15)
        })
        self.btOrder.setImage(img, for: .normal)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(HomeCellGeneric<ProductCartView>.self, forCellReuseIdentifier: ProductCartView.identifier)
        tableView.register(HomeCellGeneric<TotalPriceView>.self, forCellReuseIdentifier: TotalPriceView.identifier)
        tableView.register(HomeCellGeneric<AddCartView>.self, forCellReuseIdentifier: AddCartView.identifier)
        
        tap.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(tap)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                                        NSAttributedString.Key.font: UIFont(name: "Montserrat-Medium", size: 15.0) ?? UIImage() ]
        self.setStatusBar(backgroundColor: UIColor(named: "ColorApp") ?? .white)
    }
    private func setupRX() {
        self.viewModel.setupRX()
        
        
        self.viewModel.indicator.asObservable().bind(onNext: { (item) in
            item ? LoadingManager.instance.show() : LoadingManager.instance.dismiss()
        }).disposed(by: disposeBag)
        
        self.viewModel.$isLogin.asObservable()
            .bind(onNext: weakify({ (isLogin, wSelf) in
                guard isLogin else {
                    wSelf.moveToLogin()
                    return
                }
            })).disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(Notification.Name(rawValue: PushNotificationKeys.didUpdateCartProduct.rawValue))
            .asObservable()
            .bind { _ in
                //warning this function will be call Where can update the method getCartProduct
                self.viewModel.dataSource = RealmManager.shared.getCartProduct()
                self.postCart(dataSource: self.viewModel.dataSource)
            }.disposed(by: disposeBag)
        
        self.viewModel.$cartDetail.asObservable().bind(onNext: weakify({ (card, wSelf) in
            wSelf.cardDetail = card
            wSelf.tableView.reloadData()
        })).disposed(by: disposeBag)
        
        self.viewModel.$dataSource.bind(onNext: weakify({ (list, wSelf) in
            wSelf.postCart(dataSource: list)
            wSelf.dataSource = list
            wSelf.tableView.reloadData()
        })).disposed(by: disposeBag)
        
        self.viewModel.$giftCode.asObservable().bind(onNext: weakify({ (g, wSelf) in
            wSelf.promotionCode = g?.giftCode
            wSelf.postCart(dataSource: wSelf.viewModel.dataSource)
        })).disposed(by: disposeBag)
        
        self.viewModel.$promotionCode.asObservable().bind(onNext: weakify({ (p, wSelf) in
            wSelf.promotionCode = p?.promotionCode
            wSelf.postCart(dataSource: wSelf.viewModel.dataSource)
        })).disposed(by: disposeBag)
        
//        Observable.combineLatest(self.viewModel.$dataSource, self.isReloadTableView)
//            .asObservable().bind(onNext: weakify({ (list, wSelf) in
//                guard list.0.count > 0 else {
//                    wSelf.dataSource = []
//                    wSelf.viewModel.totalProduct = 0
//                    wSelf.tableView.reloadData()
//                    return
//                }
//                wSelf.dataSource = list.0
//                wSelf.viewModel.totalProduct = 0
//                list.0.forEach { (item) in
//                    let total = Double(item.productOtionPrice ?? 0) * Double(item.count ?? 0)
//                    wSelf.viewModel.addProduct.onNext((TypeAddCart.add, total))
//                }
//                if list.1 {
//                    wSelf.tableView.reloadData()
//                } else {
//                    wSelf.tableView.beginUpdates()
//                    wSelf.tableView.endUpdates()
//                }
//
//            })).disposed(by: disposeBag)
        
//        Observable.combineLatest(self.viewModel.$totalProduct, self.isReloadTableView)
//            .asObservable().bind { [weak self] (total, isReload) in
//                guard let wSelf = self else {
//                    return
//                }
//                wSelf.total = total
//                wSelf.tableView.reloadData()
//                let index = IndexPath(row: wSelf.dataSource.count, section: 0)
//                guard let cell = wSelf.tableView.cellForRow(at: index) as? HomeCellGeneric<TotalPriceView> else {
//                    return
//                }
//                cell.view.setupDiscount(total: wSelf.total, promotionCode: self?.promotionCode)
//            }.disposed(by: disposeBag)
        
        
//        Observable.combineLatest(self.viewModel.$promotionCode, self.viewModel.$dataSource)
//            .asObservable().bind(onNext: weakify({ (p, wSelf) in
//                wSelf.promotionCode = p.0
////                let index = IndexPath(row: wSelf.dataSource.count, section: 0)
////                guard let cell = wSelf.tableView.cellForRow(at: index) as? HomeCellGeneric<TotalPriceView> else {
////                    return
////                }
////                cell.view.setupDiscount(total: self.total, promotionCode: p.0)
//                wSelf.postCart(dataSource: wSelf.viewModel.dataSource)
//            })).disposed(by: disposeBag)
        
        self.viewModel.$err.asObservable().bind(onNext: weakify({ (textErr, wSelf) in
            guard let text = textErr else {
                return
            }
            wSelf.showAlert(title: nil, message: text)
        })).disposed(by: disposeBag)
        
        self.btOrder.rx.tap.bind(onNext: weakify({ (_, wSelf) in
            guard wSelf.dataSource.count > 0 else {
                wSelf.showAlert(title: nil, message: "Bạn chưa có sản phẩm nào?")
                return
            }
            let vc = FormOfDeliveryVC(nibName: "FormOfDeliveryVC", bundle: nil)
            vc.hidesBottomBarWhenPushed = true
            vc.listOrder = self.dataSource
            vc.total = self.total
            vc.promotionCode = self.promotionCode
            vc.cardDetail = self.cardDetail
            wSelf.navigationController?.pushViewController(vc, animated: true)
        })).disposed(by: disposeBag)
        
        self.tap.rx.event.bind { _ in
            self.view.endEditing(true)
        }.disposed(by: disposeBag)
    }
    private func moveToLogin() {
        let vc = STORYBOARD_AUTH.instantiateViewController(withIdentifier: LoginVC.className) as! LoginVC
        vc.hidesBottomBarWhenPushed = false
        vc.typeLogin = .rate
        vc.delegateRate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    private func postCart(dataSource: [HomeDetailModel]) {
        guard dataSource.count > 0 else {
            return
        }
        var p: [String: Any] = [:]
        var listProduct: [(Int, Int)] = []
        dataSource.forEach { (o) in
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
        
        if let promotion = self.promotionCode {
            p["gift_code"] = promotion
        }
        self.viewModel.getCartInfo(p: p)
    }
    private func runAnimate(by keyboarInfor: KeyboardInfo?) {
        guard let i = keyboarInfor else {
            return
        }
        let bottom = view.safeAreaInsets.bottom
        let h = (i.height > 0) ? (i.height - 97 - 40 - bottom) : 10
        let d = i.duration
        
        UIView.animate(withDuration: d) {
            self.bottomTableView.constant = h
        }
    }
}
extension CartVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.dataSource.count <= 0 {
            return 0
        }
        return self.dataSource.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case self.dataSource.count:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TotalPriceView.identifier) as? HomeCellGeneric<TotalPriceView> else {
                fatalError("Not implement")
            }
            if let card = self.cardDetail {
                cell.view.updateUITotalPrice(cartDetail: card)
            }
            cell.view.textPromotion = { text in
//                self.viewModel.promotionValid(text: text)
                self.promotionCode = text
                self.postCart(dataSource: self.dataSource)
            }
            cell.view.removeCode = {
                self.viewModel.promotionCode = nil
            }
            cell.view.removeView(views: [cell.view.viewFeeShip])
            cell.view.animateKeyboard = { [weak self] k in
                self?.runAnimate(by: k)
            }
            cell.view.listDiscount = {
                let vc = ListPromotionVC(nibName: "ListPromotionVC", bundle: nil)
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductCartView.identifier) as? HomeCellGeneric<ProductCartView> else {
                fatalError("Not implement")
            }
            let item = self.dataSource[indexPath.row]
            cell.view.setupDisplay(item: item)
            cell.view.countProduct = { type, value in
                self.viewModel.addProduct.onNext((type, value))
            }
            cell.view.deleteRow = { [weak self]  in
                guard  let wSelf = self else {
                    return
                }
                wSelf.showAlert(title: nil, message: "Bạn có muốn xoá sản phẩm", buttonTitles: ["Đóng", "Đồng ý"]) { idx in
                    if idx == 1 {
                        wSelf.viewModel.indexDelete = indexPath.row
                    }
                }
                
            }
            return cell
        }
    }
    
    
}
extension CartVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v: UIView = UIView()
        
        
        let btDeleteAll: UIButton = UIButton(type: .custom)
        let underLineButton: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Montserrat-Regular", size: 12.0) as Any ,
            .foregroundColor: UIColor.black,
            .underlineStyle: NSUnderlineStyle.single.rawValue]
        let attributeString = NSMutableAttributedString(string: "Xoá tất cả",
                                                        attributes: underLineButton)
        btDeleteAll.setAttributedTitle(attributeString, for: .normal)
        v.addSubview(btDeleteAll)
        btDeleteAll.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.right.equalToSuperview().inset(34)
            make.height.equalTo(15)
        }
        
        btDeleteAll.rx.tap.bind { [weak self] _ in
            guard  let wSelf = self else {
                return
            }
            wSelf.showAlert(title: nil, message: "Bạn có muốn xoá tất cả sản phẩm", buttonTitles: ["Đóng", "Đồng ý"]) { idx in
                if idx == 1 {
                    wSelf.viewModel.removeAll()
                }
            }
        }.disposed(by: disposeBag)
        
        let lbProduct: UILabel = UILabel(frame: .zero)
        lbProduct.text = "Bạn có \(self.dataSource.count) sản phẩm trong giỏ hàng"
        lbProduct.font = UIFont(name: "Montserrat-Medium", size: 12.0)
        v.addSubview(lbProduct)
        lbProduct.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(36)
            make.height.equalTo(15)
            make.centerY.equalTo(btDeleteAll)
        }
        
        return v
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}
extension CartVC: RateLoginDelegate {
    func callBack() {
        self.navigationController?.popViewController(animated: true, {
            self.postCart(dataSource: self.dataSource)
        })
    }
}
extension CartVC: SelectPromotionCallBackDelegate {
    func selectPromotion(model: GiftCodeModel) {
        self.navigationController?.popViewController(animated: true, {
            self.viewModel.giftCode = model
            guard let cell = self.tableView.cellForRow(at: IndexPath(row: self.dataSource.count, section: 0)) as? HomeCellGeneric<TotalPriceView> else {
                return
            }
            cell.view.tfPromotionCode.text = model.giftCode ?? ""
        })
    }
}
