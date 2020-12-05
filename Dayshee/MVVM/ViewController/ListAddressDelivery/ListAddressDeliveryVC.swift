//
//  ListAddressDeliveryVC.swift
//  Dayshee
//
//  Created by paxcreation on 11/17/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DZNEmptyDataSet
import ViewAnimator

enum typeCarListAddress {
    case cart
    case setting
}
protocol AddressModelSelectDelegate {
    func selectItem(item: AddressModel)
}

class ListAddressDeliveryVC: UIViewController {

    var currentSelect: AddressModel?
    var delegate: AddressModelSelectDelegate?
    var typeListAddress: typeCarListAddress = .cart
    private let tableView: UITableView = UITableView(frame: .zero, style: .grouped)
    private let btConfirm: UIButton = UIButton(frame: .zero)
    @VariableReplay private var dataSource: [AddressModel] = []
    private let viewModel: ListAddressDeliveryVM = ListAddressDeliveryVM()
    private var disposeRequest: Disposable?
    private var currentPage: Int = 1
    private var distanceItemRequest = 5
    {
        didSet {
            assert(distanceItemRequest >= 0, "Check !!!!!!")
        }
    }
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        visualize()
        setupRX()
        let token = Token()
        print("\(token.token)")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
}
extension ListAddressDeliveryVC {
    private func visualize() {
        let buttonLeft = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
        buttonLeft.setImage(UIImage(named: "ic_arrow_left_black"), for: .normal)
        buttonLeft.contentEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        let leftBarButton = UIBarButtonItem(customView: buttonLeft)

        navigationItem.leftBarButtonItem = leftBarButton
        buttonLeft.rx.tap.bind { _ in
            self.navigationController?.popViewController()
        }.disposed(by: disposeBag)

        title = "Danh sách địa chỉ giao hàng"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                                        NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 19.0) ?? UIImage() ]
        let vLine: UIView = UIView(frame: .zero)
        vLine.backgroundColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
        self.view.addSubview(vLine)
        vLine.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
        
        btConfirm.setTitle("Thêm địa chỉ mới", for: .normal)
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
        let img: UIImage = UIImage(named: "ic_plus_setting") ?? UIImage()
        btConfirm.imageView?.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(25)
            make.width.height.equalTo(18)
        })
        btConfirm.setImage(img, for: .normal)
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.allowsSelection = true
        tableView.sectionHeaderHeight = 0.1
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        self.view.addSubview(self.tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.btConfirm.snp.top).inset(-10)
            make.top.equalTo(vLine.snp.bottom)
        }
        tableView.delegate = self
        tableView.prefetchDataSource = self
        tableView.register(DeliveryCell.nib, forCellReuseIdentifier: DeliveryCell.identifier)
    }
    private func setupRX() {
        self.viewModel.getListAddressCallBack()
        
        self.viewModel.indicator.asObservable().bind { (isLoad) in
            isLoad ? LoadingManager.instance.show() : LoadingManager.instance.dismiss()
        }.disposed(by: disposeBag)
        
        self.$dataSource.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: DeliveryCell.identifier, cellType: DeliveryCell.self)) {(row, element, cell) in
                cell.lbName.text = element.name
                cell.lbPhone.text = element.phone
                let address = element.address ?? ""
                let ward = element.ward?.ward ?? ""
                let d = element.district?.district ?? ""
                let p = element.province?.province ?? ""
                cell.lbContent.text = "\(address), \(ward), \(d), \(p)"
                let isDefault = element.isDefault ?? false
                if isDefault {
                    cell.bottomButton.priority = .defaultLow
                    cell.bottomContent.priority = .required
                } else {
                    cell.bottomContent.priority = .defaultLow
                    cell.bottomButton.priority = .required
                }
                cell.btSetDefault.isHidden = isDefault
                cell.imgCheck.isHidden = (element.id == self.currentSelect?.id) ? false : true
                cell.vCheck.backgroundColor = (element.id == self.currentSelect?.id) ? .black : .white
                cell.btClose.isHidden = (element.id == self.currentSelect?.id) ? true : false
                cell.deleteAddress = {
                    let id = self.dataSource[row].id ?? 0
                    self.viewModel.deleteAddress(id: id)
                    for (index, i) in self.dataSource.enumerated() {
                        if id == i.id {
                            self.dataSource.remove(at: index)
                        }
                    }
                    let cells = self.tableView.visibleCells
                    let rotateAnimation = AnimationType.vector(CGVector(dx: .random(in: -10...10), dy: .random(in: -30...30)))
                    UIView.animate(views: cells, animations: [rotateAnimation, rotateAnimation], duration: 0.5)
                    self.tableView.beginUpdates()
                    self.tableView.endUpdates()
                }
                cell.updateDefaultAddress = {
                    if let id = element.id {
                        let p: [String: Any] = ["id": id]
                        self.viewModel.updateDefaultAddress(p: p)
                    }
                }
        }.disposed(by: disposeBag)
        
        self.viewModel.$updateAddressDefault.asObservable().bind(onNext: weakify({ (a, wSelf) in
            if let f = self.dataSource.first,  f.isDefault == true {
                wSelf.dataSource[0].isDefault = false
            }
            for (index, i) in self.dataSource.enumerated() {
                if a.id == i.id {
                    wSelf.dataSource.remove(at: index)
                }
            }
            wSelf.dataSource.insert(a, at: 0)
            wSelf.tableView.beginUpdates()
            self.tableView.endUpdates()
            let index = IndexPath(row: 0, section: 0)
            wSelf.tableView.scrollToRow(at: index, at: .top, animated: true)
        })).disposed(by: disposeBag)
        
        self.btConfirm.rx.tap.bind { _ in
            let vc = DeliveryAddress()
            vc.delegate = self
            vc.typeAddress = .addNewList
            self.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: disposeBag)
        
        self.tableView.rx.itemSelected.bind(onNext: weakify({ (idx, wSelf) in
            guard wSelf.typeListAddress == .setting else {
                let item = self.dataSource[idx.row]
                wSelf.delegate?.selectItem(item: item)
                return
            }
            let vc = DeliveryAddress()
            let item = wSelf.dataSource[idx.row]
            vc.user = item
            vc.delegate = self
            vc.typeAddress = .updateAddress
            self.navigationController?.pushViewController(vc, animated: true)
        })).disposed(by: disposeBag)
        
        self.viewModel.$listAddressCallBack.asObservable().bind(onNext: weakify({ (item, wSelf) in
            guard let l = item.data else {
                return
            }
            wSelf.currentPage = 1
            wSelf.dataSource = l
            let cells = wSelf.tableView.visibleCells
            let rotateAnimation = AnimationType.vector(CGVector(dx: .random(in: -10...10), dy: .random(in: -30...30)))
            UIView.animate(views: cells, animations: [rotateAnimation, rotateAnimation], duration: 0.5)
            wSelf.tableView.scrollToTop()
            wSelf.tableView.reloadData()
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
extension ListAddressDeliveryVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
}
extension ListAddressDeliveryVC: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let idx = indexPaths.last?.item else { return }
        let total = self.dataSource.count
        guard total - idx <= distanceItemRequest else { return }
        self.currentPage += 1
        requestData(currentPage: self.currentPage)
    }
}
extension ListAddressDeliveryVC: UpdateAddressDelegate {
    func updateAddress(item: AddressModel) {
        guard let isDefault = item.isDefault else {
            return
        }
        self.navigationController?.popToViewController(self, animated: true)
        self.tableView.beginUpdates()
        if let f = self.dataSource.first,  f.isDefault == true {
            self.dataSource[0].isDefault = (isDefault) ? false : true
        }
        if isDefault {
            for (index, i) in self.dataSource.enumerated() {
                if item.id == i.id {
                    self.dataSource.remove(at: index)
                }
            }
            self.dataSource.insert(item, at: 0)
        } else {
            for (index, i) in self.dataSource.enumerated() {
                if item.id == i.id {
                    self.dataSource[index] = item
                }
            }
        }
        self.tableView.endUpdates()
    }
    func addNewAddressCart(item: AddressModel) {
        guard let isDefault = item.isDefault else {
            return
        }
        self.navigationController?.popToViewController(self, animated: true)
        if let f = self.dataSource.first,  f.isDefault == true {
            self.dataSource[0].isDefault = (item.isDefault ?? false) ? false : true
        }
        if isDefault {
            self.dataSource.insert(item, at: 0)
        } else {
            self.dataSource.insert(item, at: (self.dataSource.first?.isDefault ?? false) ? 1 : 0)
        }
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        let index = IndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: index, at: .top, animated: true)
    }
}
extension ListAddressDeliveryVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "Hiện tại bạn chưa có điạ chỉ"
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                   NSAttributedString.Key.font: UIFont.systemFont(ofSize: 19) ]
        let t = NSAttributedString(string: text, attributes: titleTextAttributes)
        return t
    }
}

