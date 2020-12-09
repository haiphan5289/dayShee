//
//  OrdersVC.swift
//  MVVM_2020
//
//  Created by Admin on 10/28/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DZNEmptyDataSet

enum StatusOrder: Int {
    case PENDING, ACCEPTED, DELIVERING, DELIVERED, CANCELED, COMPLETED
    var text: String {
        return "\(self)"
    }
    var textStatus: String {
        switch self {
        case .ACCEPTED:
            return "Đặt hàng thành công"
        case .DELIVERING:
            return "Đang giao hàng"
        case .DELIVERED:
            return "Đã giao hàng"
        case .COMPLETED:
            return "Hoàn thành"
        case .PENDING:
            return "Đang xử lý hàng"
        case .CANCELED:
            return "Đã huỷ"
        }
    }
    var img: UIImage? {
        switch self {
        case .COMPLETED:
            return UIImage(named: "ic_done_detail")
        case .CANCELED:
            return UIImage(named: "ic_close_detail")
        default:
            return UIImage(named: "ic_pending_detail")
        }
    }
}

class OrdersVC: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @VariableReplay private var dataSource: [OrderModel] = []
    private let viewModel: OrdersVM = OrdersVM()
    private var currentPage: Int = 1
    private var distanceItemRequest = 5
    {
        didSet {
            assert(distanceItemRequest >= 0, "Check !!!!!!")
        }
    }
    private let disposeBag = DisposeBag()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        let token = Token()
        if token.tokenExists {
            self.viewModel.getListAddressCallBack()
        } else {
            dataSource = []
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        visualize()
        setupRX()
    }
}
extension OrdersVC {
    private func visualize() {
        tableView.delegate = self
        tableView.prefetchDataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.register(nibWithCellClass: OrderCell.self)
        tableView.tableFooterView = UIView()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                                        NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 19.0) ?? UIImage() ]
    }
    private func setupRX() {
    
        self.viewModel.indicator.asObservable().bind { (isLoad) in
            isLoad ? LoadingManager.instance.show() : LoadingManager.instance.dismiss()
        }.disposed(by: disposeBag)
        
        self.$dataSource.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: OrderCell.identifier, cellType: OrderCell.self)) {(row, element, cell) in
                guard let idStatus = element.orderStatus?.status else {
                    return
                }
                cell.lbCode.text = "\(element.id ?? 0)"
                cell.lbOrderDate.text = element.createdAt
                cell.lbPrice.text = element.total?.currency
                if let status = StatusOrder(rawValue: idStatus) {
                    cell.lbStatus.text = status.textStatus
                    cell.imgStatus.image = status.img
                } else {
                    cell.lbStatus.text = "unknow"
                }
                guard let count = element.products?.count, let first = element.products?.first else {
                    return
                }
                guard let name = first.name else {
                    return
                }
                cell.lbName.text = (count > 1) ? "\(name) và \(count - 1) sản phẩm khác" : "\(name)"
        }.disposed(by: disposeBag)
        
        self.tableView.rx.itemSelected.bind(onNext: weakify({ (idx, wSelf) in
            let vc = STORYBOARD_ORDERS.instantiateViewController(withIdentifier: OrderDetailVC.className) as! OrderDetailVC
            vc.hidesBottomBarWhenPushed = true
            let id = wSelf.dataSource[idx.row].id
            vc.id = id
            self.navigationController?.pushViewController(vc, animated: true)
        })).disposed(by: disposeBag)
        
        self.viewModel.$listOrderCallBack.asObservable().bind(onNext: weakify({ (item, wSelf) in
            guard let l = item.data else {
                return
            }
            wSelf.currentPage = 1
            wSelf.dataSource = l
            wSelf.tableView.scrollToTop()
        })).disposed(by: disposeBag)
    }
    private func requestData(currentPage: Int) {
        self.viewModel.getListAddressCheck(page: currentPage)
            .asObservable()
            .bind(onNext: { [weak self] (result) in
                switch result {
                case .success(let value):
                    guard let wSelf = self, let data = value.data,
                          let model = data, let lastPage = model.total,
                          wSelf.dataSource.count < lastPage else {
                        return
                    }
                    wSelf.dataSource += model.data ?? []
                    wSelf.tableView.beginUpdates()
                    wSelf.tableView.endUpdates()
                case .failure(let err):
                    self?.showAlert(title: nil, message: err.message)
                }
            }).disposed(by: disposeBag)
    }
}
extension OrdersVC : UITableViewDelegate  {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
extension OrdersVC: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let idx = indexPaths.last?.item else { return }
        let total = self.dataSource.count
        guard total - idx <= distanceItemRequest else { return }
        self.currentPage += 1
        requestData(currentPage: self.currentPage)
    }
}
extension OrdersVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "Hiện tại bạn chưa có đơn hàng"
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                   NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 19.0) ]
        let t = NSAttributedString(string: text, attributes: titleTextAttributes as [NSAttributedString.Key : Any])
        return t
    }
}
