//
//  OrderDetailVC.swift
//  Dayshee
//
//  Created by Apple on 11/7/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class OrderDetailVC: UIViewController {
    
    var id: Int?
    private let tableView: UITableView = UITableView(frame: .zero, style: .grouped)
    private let viewModel: OrderDetailVM = OrderDetailVM()
    private let disposeBag = DisposeBag()
    private var orderInfo: OrderInfo?
    private var location: [Location] = []
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.viewModel.getOrder(id: self.id ?? 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        visualize()
        setupRX()
    }
    
}
extension OrderDetailVC {
    private func visualize() {
        let buttonLeft = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
        buttonLeft.setImage(UIImage(named: "ic_arrow_left_black"), for: .normal)
        buttonLeft.contentEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        let leftBarButton = UIBarButtonItem(customView: buttonLeft)
        
        navigationItem.leftBarButtonItem = leftBarButton
        buttonLeft.rx.tap.bind { _ in
            self.navigationController?.popViewController()
        }.disposed(by: disposeBag)
        
        title = "Chi tiết đơn hàng"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                                        NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 19.0) ?? UIImage() ]
        
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.sectionHeaderHeight = 0.1
        self.view.addSubview(self.tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(self.view.safeAreaInsets).inset(4)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(nibWithCellClass: InforOrderTBCell.self)
        tableView.register(nibWithCellClass: AddressOrderTBCell.self)
        tableView.register(HomeCellGeneric<DeliveryDetailView>.self, forCellReuseIdentifier: DeliveryDetailView.identifier)
        tableView.register(HomeCellGeneric<OrderDetailView>.self, forCellReuseIdentifier: OrderDetailView.identifier)
        tableView.register(HomeCellGeneric<TotalPriceView>.self, forCellReuseIdentifier: TotalPriceView.identifier)
        tableView.register(HomeCellGeneric<NoteView>.self, forCellReuseIdentifier: NoteView.identifier)
        
        let vLine: UIView = UIView(frame: .zero)
        vLine.backgroundColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
        self.view.addSubview(vLine)
        vLine.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
    }
    private func setupRX() {
        
        self.viewModel.indicator.asObservable().bind(onNext: { (item) in
            item ? LoadingManager.instance.show() : LoadingManager.instance.dismiss()
        }).disposed(by: disposeBag)
        
        self.viewModel.$orderModel.asObservable().bind(onNext: weakify({ (item, wSelf) in
            wSelf.orderInfo = item
            wSelf.tableView.reloadData()
        })).disposed(by: disposeBag)
        
        self.viewModel.$location.asObservable().bind(onNext: weakify({ (l, wSelf) in
            wSelf.location = l
            wSelf.tableView.reloadData()
        })).disposed(by: disposeBag)
        
        self.viewModel.$cancelSuccess.asObservable().bind(onNext: weakify({ (isSuccess, wSelf) in
            guard isSuccess else {
                return
            }
            wSelf.navigationController?.popViewController()
        })).disposed(by: disposeBag)
        
        if let list = RealmManager.shared.getListLocation(), list.count > 0 {
            self.location = list
        } else {
            self.viewModel.getLocaion()
        }
    }

}
extension OrderDetailVC : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0 :
            let cell = tableView.dequeueReusableCell(withClass: InforOrderTBCell.self)
            cell.actionNext = {
                let vc = TrackingOrder(nibName: "TrackingOrder", bundle: nil)
                vc.orderStatuses = self.orderInfo?.orderStatuses
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            guard let item = self.orderInfo else {
                return cell
            }
            cell.setupInfoOrder(item: item)
            return cell
        case 1 :
            let cell = tableView.dequeueReusableCell(withClass: AddressOrderTBCell.self)
            guard let item = self.orderInfo else {
                return cell
            }
            cell.setupDisplay(item: item, list: self.location)
            return cell
            
//        case 2 :
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: DeliveryDetailView.identifier) as? HomeCellGeneric<DeliveryDetailView> else {
//                fatalError("Not implement")
//            }
//            guard let deliveryMode = self.orderInfo?.delivery else {
//                return cell
//            }
//            cell.view.setupDisplay(item: [deliveryMode])
//            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderDetailView.identifier) as? HomeCellGeneric<OrderDetailView> else {
                fatalError("Not implement")
            }
            guard let l = self.orderInfo?.orderDetails else {
                return cell
            }
            cell.view.setupDisplay(item: l)
            cell.view.updateCell = { 
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteView.identifier) as? HomeCellGeneric<NoteView> else {
                fatalError("Not implement")
            }
            cell.view.setupFromOrderDetail(text: self.orderInfo?.note)
            cell.view.upateHeightNoteView = {
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }
            return cell
        default :
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TotalPriceView.identifier) as? HomeCellGeneric<TotalPriceView> else {
                fatalError("Not implement")
            }
            cell.view.hideButtonRemove()
            cell.view.removeView(views: [cell.view.vPromotion])
            guard let item = self.orderInfo else {
                return cell
            }
            cell.view.setupUIFromOrderDetail(item: item)
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v: UIView = UIView()
        let btCancel: UIButton = UIButton(frame: .zero)
        btCancel.setTitle("Huỷ đơn", for: .normal)
        btCancel.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 15)
        btCancel.backgroundColor = .black
        btCancel.clipsToBounds = true
        btCancel.layer.cornerRadius = 6
        v.addSubview(btCancel)
        btCancel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.equalTo(44)
            make.left.right.equalToSuperview().inset(20)
        }
        
        btCancel.rx.tap.bind { [weak self] _ in
            guard let wSefl = self, let id = wSefl.id else {
                return
            }
            wSefl.showAlert(title: "Thông báo", message: "Bạn có muốn huỷ đơn", buttonTitles: ["Đóng", "Đồng ý"]) { idx in
                if idx == 1 {
                    let p: [String: Any] = ["id": id, "reason": "Hết tiền lấy hàng"]
                    wSefl.viewModel.cancelOrder(p: p)
                }
            }
        }.disposed(by: disposeBag)
        return v
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let item = self.orderInfo else {
            return 0
        }
        guard let stt = item.orderStatus?.status, let textStt = StatusOrder(rawValue: stt) else {
            return 0
        }
        if textStt == .PENDING {
            return 100
        }
        return 0
    }
}
