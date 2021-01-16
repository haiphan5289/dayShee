//
//  ListFavouriteVC.swift
//  Dayshee
//
//  Created by paxcreation on 11/17/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DZNEmptyDataSet
import Kingfisher
import ViewAnimator

class ListFavouriteVC: UIViewController {

    private let tableView: UITableView = UITableView(frame: .zero, style: .grouped)
    @VariableReplay private var dataSource: [Product] = []
    private var viewModel: ListFavouriteVM = ListFavouriteVM()
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
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
extension ListFavouriteVC {
    private func visualize() {
        let buttonLeft = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
        buttonLeft.setImage(UIImage(named: "ic_arrow_left_black"), for: .normal)
        buttonLeft.contentEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        let leftBarButton = UIBarButtonItem(customView: buttonLeft)

        navigationItem.leftBarButtonItem = leftBarButton
        buttonLeft.rx.tap.bind { _ in
            self.navigationController?.popViewController()
        }.disposed(by: disposeBag)

        title = "Danh sách sản phẩm yêu thích"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                                        NSAttributedString.Key.font: UIFont(name: "Montserrat-Medium", size: 15.0) ?? UIImage() ]
        self.navigationController?.navigationBar.barTintColor = .white
        let vLine: UIView = UIView(frame: .zero)
        vLine.backgroundColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
        self.view.addSubview(vLine)
        vLine.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
        
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        tableView.backgroundColor = .white
        tableView.sectionHeaderHeight = 0.1
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        self.view.addSubview(self.tableView)
        tableView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(vLine.snp.bottom)
        }
        tableView.delegate = self
        tableView.register(ListFavouriteCell.nib, forCellReuseIdentifier: ListFavouriteCell.identifier)
    }
    private func setupRX() {
        self.viewModel.getListFavouriteCallBack()
        
        self.viewModel.indicator.asObservable().bind { (isLoad) in
            isLoad ? LoadingManager.instance.show() : LoadingManager.instance.dismiss()
        }.disposed(by: disposeBag)
        
        self.$dataSource.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: ListFavouriteCell.identifier, cellType: ListFavouriteCell.self)) {(row, element, cell) in
                cell.lbName.text = "\(element.name ?? "")"
                
                if let textUrl = element.imageURL, let url = URL(string: textUrl) {
                    cell.img.kf.setImage(with: url)
                }
                
                if let first = element.productOptions?.first {
                    cell.lbPrice.text = first.price?.currency
                }
                
                cell.removeProduce = {
                    guard let id = element.id else {
                        return
                    }
                    let p: [String: Any] = ["product_id": id]
                    self.viewModel.dislike(p: p)
                    self.dataSource.remove(at: row)
                    self.tableView.beginUpdates()
                    self.tableView.endUpdates()
                }
        }.disposed(by: disposeBag)
        
        self.tableView.rx.itemSelected.bind(onNext: weakify({ (idx, wSelf) in
            let vc = ProductDetail(nibName: "ProductDetail", bundle: nil)
            let id = self.dataSource[idx.row].id
            vc.produceID = id
            self.navigationController?.pushViewController(vc, animated: true)
        })).disposed(by: disposeBag)
        
        self.viewModel.$listFavouriteCallBack.asObservable().bind(onNext: weakify({ (item, wSelf) in
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
        
        self.viewModel.$dislike.asObservable().bind { [weak self] (f) in
            guard let wSefl = self else {
                return
            }
            wSefl.showAlert(title: nil, message: f)
        }.disposed(by: disposeBag)
    }
    private func requestData(currentPage: Int) {
        self.viewModel.getListFavourite(page: currentPage)
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
extension ListFavouriteVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
}
extension ListFavouriteVC: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let idx = indexPaths.last?.item else { return }
        let total = self.dataSource.count
        guard total - idx <= distanceItemRequest else { return }
        self.currentPage += 1
        requestData(currentPage: self.currentPage)
    }
}

extension ListFavouriteVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "Hiện tại bạn chưa có sản phẩm yêu thích"
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                   NSAttributedString.Key.font: UIFont(name: "Montserrat-Medium", size: 15) ]
        let t = NSAttributedString(string: text, attributes: titleTextAttributes as [NSAttributedString.Key : Any])
        return t
    }
}

