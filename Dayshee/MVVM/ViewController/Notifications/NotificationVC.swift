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
import DZNEmptyDataSet
import Kingfisher
import ViewAnimator

class NotificationVC: BaseHiddenNavigationController {

    @IBOutlet weak var tableView: UITableView!
    @VariableReplay private var dataSource: [NotificationModel] = []
    private var viewModel: ListNotificationVM = ListNotificationVM()
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
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        visualize()
        setupRX()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
                                                                        NSAttributedString.Key.font: UIFont(name: "Montserrat-Medium", size: 19.0) ?? UIImage() ]
        self.setStatusBar(backgroundColor: UIColor(named: "ColorApp") ?? .white)
    }
    private func setupRX() {
        self.viewModel.getlistNotificationCallBack()
        
        self.viewModel.indicator.asObservable().bind { (isLoad) in
            isLoad ? LoadingManager.instance.show() : LoadingManager.instance.dismiss()
        }.disposed(by: disposeBag)
        
        self.$dataSource.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: NotificationCell.identifier, cellType: NotificationCell.self)) {(row, element, cell) in
                guard let notify = element.notificationType else {
                    return
                }
                cell.lbTitle.text = notify.title
                cell.lbContent.text = notify.message
                cell.lbTime.text = element.updatedAt
                if let isRead = element.isRead {
                    cell.imgDot.isHidden = isRead
                }
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.bind { (idx) in
            let vc = NotificationDetailVC(nibName: "NotificationDetailVC", bundle: nil)
            vc.hidesBottomBarWhenPushed = true
            vc.item = self.dataSource[idx.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: disposeBag)
        
        self.viewModel.$listNotificationCallBack.asObservable().bind(onNext: weakify({ (item, wSelf) in
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
        self.viewModel.getlistNotification(page: currentPage)
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
extension NotificationVC: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
}
extension NotificationVC: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let idx = indexPaths.last?.item else { return }
        let total = self.dataSource.count
        guard total - idx <= distanceItemRequest else { return }
        self.currentPage += 1
        requestData(currentPage: self.currentPage)
    }
}

extension NotificationVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "Hiện tại bạn chưa có thông báo?"
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                   NSAttributedString.Key.font: UIFont(name: "Montserrat-Medium", size: 15) ]
        let t = NSAttributedString(string: text, attributes: titleTextAttributes as [NSAttributedString.Key : Any])
        return t
    }
}
