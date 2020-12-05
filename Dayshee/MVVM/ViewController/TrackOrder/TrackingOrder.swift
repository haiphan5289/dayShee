//
//  TrackingOrder.swift
//  Dayshee
//
//  Created by haiphan on 11/21/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class TrackingOrder: UIViewController {
    
    private let tableView: UITableView = UITableView(frame: .zero, style: .grouped)
    var orderStatuses: [OrderStatus]?
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
extension TrackingOrder {
    private func visualize() {
        let buttonLeft = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
        buttonLeft.setImage(UIImage(named: "ic_arrow_left_black"), for: .normal)
        buttonLeft.contentEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        let leftBarButton = UIBarButtonItem(customView: buttonLeft)
        
        navigationItem.leftBarButtonItem = leftBarButton
        buttonLeft.rx.tap.bind { _ in
            self.navigationController?.popViewController()
        }.disposed(by: disposeBag)
        
        title = "Theo dõi đơn hàng"
        
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
        tableView.register(TrackingOrderCell.nib, forCellReuseIdentifier: TrackingOrderCell.identifier)
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
        
    }
    private func setupRX() {
        var isCancel: Bool = false
        
        self.orderStatuses?.forEach({ (o) in
            if o.status == 4 {
                isCancel = true
            }
        })
        
        if isCancel {
            Observable.just([4])
                .bind(to: tableView.rx.items(cellIdentifier: TrackingOrderCell.identifier, cellType: TrackingOrderCell.self)) {(row, element, cell) in
                    let text = StatusOrder(rawValue: element)
                    cell.lbStatus.text = text?.textStatus
                    cell.vVertical.isHidden = true
                    cell.lbStatus.textColor = .black
                    cell.vCurrentStatus.backgroundColor = .black
                    
                }.disposed(by: disposeBag)
        } else {
            Observable.just([0,1,2,3,5])
                .bind(to: tableView.rx.items(cellIdentifier: TrackingOrderCell.identifier, cellType: TrackingOrderCell.self)) {(row, element, cell) in
                    var isHave: Bool = false
                    var statusShow: OrderStatus?
                    self.orderStatuses?.forEach({ (status) in
                        if element == status.status {
                            statusShow = status
                            isHave = true
                        }
                    })
                    cell.lbStatus.textColor = (isHave) ? .black : #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
                    cell.vVertical.backgroundColor = (isHave) ? .black : #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
                    cell.vCurrentStatus.backgroundColor = (isHave) ? .black : #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
                    cell.lbTime.text = (isHave) ? statusShow?.createdAt : ""
                    let text = StatusOrder(rawValue: element)
                    cell.lbStatus.text = text?.textStatus
                    cell.vVertical.isHidden = (element == 5) ? true : false
                    
                }.disposed(by: disposeBag)
        }
        
    }
}
extension TrackingOrder: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
}
