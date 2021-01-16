//
//  TrackOrderView.swift
//  Dayshee
//
//  Created by paxcreation on 1/11/21.
//  Copyright © 2021 ThanhPham. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class TrackOrderView: UIView, UpdateDisplayProtocol, DisplayStaticHeightProtocol {
    static var height: CGFloat { return 0 }
    static var bottom: CGFloat { return 0 }
    static var automaticHeight: Bool { return true }
    
    var updateHeight: (() -> Void)?
    private let tableView: UITableView = UITableView(frame: .zero, style: .grouped)
    @VariableReplay var orderStatuses: [OrderStatus] = []
    private var listStatus: [StatusOrder] = []
    private let disposeBag = DisposeBag()
    private var heightCell = 65
    private var heightSection = 55
    private var isCancel: Bool = false
}
extension TrackOrderView: Weakifiable {
    override func awakeFromNib() {
        super.awakeFromNib()
        visualize()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    override func removeFromSuperview() {
        superview?.removeFromSuperview()
    }
    
}
extension TrackOrderView {
    func setupDisplay(item: [OrderStatus]?) {
        guard let item = item else {
            return
        }
        orderStatuses = item.sorted(by: { (o1, o2) -> Bool in
            return (o1.id ?? 0) <= (o2.id ?? 0)
        })
        setupRX()
        self.tableView.reloadData()
    }
    
    private func setupRX() {
        self.orderStatuses.forEach({ (o) in
            if let stt = StatusOrder(rawValue: o.status ?? 0) {
                if stt == .CANCELED {
                    isCancel = true
                }
            }
        })
        
        if isCancel {
            self.tableView.snp.updateConstraints { (make) in
                make.height.equalTo(self.heightCell + 4 + heightSection)
            }
            self.updateHeight?()
            self.listStatus = [.CANCELED]
        } else {
            self.tableView.snp.updateConstraints { (make) in
                let h = self.heightCell * 4
                make.height.equalTo(h + 4 + heightSection)
            }
            self.updateHeight?()
            self.listStatus = [.PENDING, .DELIVERING, .DELIVERED, .COMPLETED]
        }
    }
    private func visualize() {
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.sectionHeaderHeight = 0.1
        tableView.isScrollEnabled = false
        self.addSubview(self.tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(4)
            make.height.equalTo(0)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TrackingOrderCell.nib, forCellReuseIdentifier: TrackingOrderCell.identifier)
    }
}
extension TrackOrderView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isCancel {
            return 1
        }
        return self.listStatus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackingOrderCell.identifier) as! TrackingOrderCell
        if self.isCancel {
            let text = StatusOrder(rawValue: StatusOrder.CANCELED.rawValue)
            cell.lbStatus.text = text?.textStatus
            cell.vVertical.isHidden = true
            cell.lbStatus.textColor = .black
            cell.vCurrentStatus.backgroundColor = UIColor(named: "ColorApp")
        } else {
            var isHave: Bool = false
            var statusShow: OrderStatus?
            let element = self.listStatus[indexPath.row].rawValue
            self.orderStatuses.forEach({ (status) in
                if element == status.status {
                    statusShow = status
                    isHave = true
                }
            })
            cell.lbStatus.textColor = (isHave) ? .black : #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
            cell.vVertical.backgroundColor = (isHave) ? .black : #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
            cell.vCurrentStatus.backgroundColor = (isHave) ? UIColor(named: "ColorApp") : #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
            cell.lbTime.text = (isHave) ? statusShow?.createdAt : ""
            let text = StatusOrder(rawValue: element )
            cell.lbStatus.text = text?.textStatus
            cell.vVertical.isHidden = (element == StatusOrder.COMPLETED.rawValue) ? true : false
        }
        return cell
    }
    
    
}
extension TrackOrderView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(self.heightSection)
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v: UIView = UIView()
        
        let imgIcon: UIImageView = UIImageView(frame: .zero)
        imgIcon.image = UIImage(named: "info")
        v.addSubview(imgIcon)
        imgIcon.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(15)
            make.left.equalToSuperview().inset(40)
            make.height.width.equalTo(20)
        }
        
        let lbTitle: UILabel = UILabel(frame: .zero)
        lbTitle.text = "Theo dõi đơn hàng"
        lbTitle.font = UIFont(name: "Montserrat-Medium", size: 15)
        v.addSubview(lbTitle)
        lbTitle.snp.makeConstraints { (make) in
            make.centerY.equalTo(imgIcon)
            make.left.equalTo(imgIcon.snp.right).inset(-10)
        }
        return v
    }
}
