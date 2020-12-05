//
//  NotificationVC.swift
//  MVVM_2020
//
//  Created by Admin on 10/28/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class NotificationVC: BaseHiddenNavigationController {

    @IBOutlet weak var tableView: UITableView!
    private let disposeBag = DisposeBag()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        visualize()
        setupRX()
    }
}
extension NotificationVC {
    private func visualize() {
        tableView.backgroundColor = .white
        tableView.sectionHeaderHeight = 0.1
        tableView.estimatedSectionHeaderHeight = 0.1
        tableView.delegate = self
        tableView.register(NotificationCell.nib, forCellReuseIdentifier: NotificationCell.identifier)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                                        NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 19.0) ?? UIImage() ]
    }
    private func setupRX() {
        Observable.just([1,2,3,4])
            .bind(to: tableView.rx.items(cellIdentifier: NotificationCell.identifier, cellType: NotificationCell.self)) {(row, element, cell) in
                cell.lbContent.text = "k o ko o. ko ok ok ok ko ko ko ko ko ko k okko ko ok ko. koko.  kokkokokko ko ko ko ko ko ko ko ko ko ko ko kok ok ok ok oko ko ko ko. ko ko ok ko ko koo ko kko ok. ko"
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.bind { (idx) in
            let vc = NotificationDetailVC(nibName: "NotificationDetailVC", bundle: nil)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: disposeBag)
    }
    
}
extension NotificationVC: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
}
