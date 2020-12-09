//
//  ListDiscountVC.swift
//  Dayshee
//
//  Created by paxcreation on 11/17/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DZNEmptyDataSet
import SkeletonView

class ListDiscountVC: UIViewController {

    private let tableView: UITableView = UITableView(frame: .zero, style: .grouped)
    private let viewModel: ListDiscountVM = ListDiscountVM()
    private var isFirstLoad: Bool = true
    @VariableReplay private var dataSource: [DiscountModel] = []
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
}
extension ListDiscountVC {
    private func visualize() {
        let buttonLeft = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
        buttonLeft.setImage(UIImage(named: "ic_arrow_left_black"), for: .normal)
        buttonLeft.contentEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        let leftBarButton = UIBarButtonItem(customView: buttonLeft)

        navigationItem.leftBarButtonItem = leftBarButton
        buttonLeft.rx.tap.bind { _ in
            self.navigationController?.popViewController()
        }.disposed(by: disposeBag)

        title = "Chương trình khuyến mãi"
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
        
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.backgroundColor = .white
        tableView.sectionHeaderHeight = 0.1
        tableView.prefetchDataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        self.view.addSubview(self.tableView)
        tableView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(vLine.snp.bottom)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ListDiscountCell.nib, forCellReuseIdentifier: ListDiscountCell.identifier)
    }
    private func setupRX() {
        self.viewModel.getListAddressCallBack()
        
        self.viewModel.indicator.asObservable().bind { (isLoad) in
            isLoad ? LoadingManager.instance.show() : LoadingManager.instance.dismiss()
        }.disposed(by: disposeBag)
        
//        self.$dataSource.asObservable()
//            .bind(to: tableView.rx.items(cellIdentifier: ListDiscountCell.identifier, cellType: ListDiscountCell.self)) {(row, element, cell) in
//                cell.lbTitle.text = element.title
//                cell.lbTimeApply.text = "Áp dụng từ ngày \(element.startDate ?? "") tới ngày \(element.endDate ?? "")"
//                cell.tvContent.text = element.datumDescription
//                if let textUrl = element.imageURL, let url = URL(string: textUrl) {
//                    cell.img.kf.setImage(with: url)
//                }
//                cell.eventReadMore = { isSeeMore in
//                    self.tableView.beginUpdates()
//                    let size = self.getTextSize(text: element.datumDescription ?? "", fontSize: 14, width: cell.tvContent.bounds.width)
//                    cell.hTvContent.constant = (isSeeMore) ? (size.height + 50) : 50
//                    self.tableView.endUpdates()
//                }
//        }.disposed(by: disposeBag)
        
//        self.tableView.rx.itemSelected.bind(onNext: weakify({ (idx, wSelf) in
//            guard wSelf.typeListAddress == .setting else {
//                let item = self.dataSource[idx.row]
//                wSelf.delegate?.selectItem(item: item)
//                return
//            }
//            let vc = DeliveryAddress()
//            let item = wSelf.dataSource[idx.row]
//            vc.user = item
//            vc.delegate = self
//            vc.typeAddress = .updateAddress
//            self.navigationController?.pushViewController(vc, animated: true)
//        })).disposed(by: disposeBag)
        self.viewModel.$listDiscountCallBack.asObservable().bind(onNext: weakify({ (item, wSelf) in
            guard let l = item.data else {
                return
            }
            wSelf.currentPage = 1
            wSelf.dataSource = l
            wSelf.tableView.scrollToTop()
            wSelf.isFirstLoad = false
            wSelf.tableView.reloadData()
        })).disposed(by: disposeBag)
    }
    private func requestData(currentPage: Int) {
        self.viewModel.getListDiscount(page: currentPage)
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
    func getTextSize(text: String, fontSize: CGFloat, width: CGFloat) -> CGRect {
        let size = CGSize(width: width, height: 100000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options,
                                                   attributes: [NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: fontSize) as Any ] ,
                                                   context: nil)
    }
}
extension ListDiscountVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
}
extension ListDiscountVC: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let idx = indexPaths.last?.item else { return }
        let total = self.dataSource.count
        guard total - idx <= distanceItemRequest else { return }
        self.currentPage += 1
        requestData(currentPage: self.currentPage)
    }
}
extension ListDiscountVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "Hiện tại chưa có khuyến mãi"
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                   NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 19.0) ]
        let t = NSAttributedString(string: text, attributes: titleTextAttributes as [NSAttributedString.Key : Any])
        return t
    }
}
extension ListDiscountVC: SkeletonTableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.dataSource.count <= 0 {
            return (self.isFirstLoad) ? 10 : 0
        }
         return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: ListDiscountCell.identifier) as? ListDiscountCell else {
            fatalError()
        }
        cell.setuoSke(count: self.dataSource.count)
        guard self.dataSource.count > 0 else {
            return cell
        }
        let element = self.dataSource[indexPath.row]
        cell.lbTitle.text = element.title
        cell.lbTimeApply.text = "Áp dụng từ ngày \(element.startDate ?? "") tới ngày \(element.endDate ?? "")"
        cell.tvContent.text = element.datumDescription
        if let textUrl = element.imageURL, let url = URL(string: textUrl) {
            cell.img.kf.setImage(with: url)
        }
        cell.eventReadMore = { isSeeMore in
            self.tableView.beginUpdates()
            let size = self.getTextSize(text: element.datumDescription ?? "", fontSize: 14, width: cell.tvContent.bounds.width)
            cell.hTvContent.constant = (isSeeMore) ? (size.height + 50) : 50
            self.tableView.endUpdates()
        }
        return cell
    }
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return ListDiscountCell.identifier
    }
    
}

