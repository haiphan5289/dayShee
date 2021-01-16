//
//  ListPromotionVC.swift
//  Dayshee
//
//  Created by haiphan on 1/9/21.
//  Copyright © 2021 ThanhPham. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SkeletonView

protocol SelectPromotionCallBackDelegate {
    func selectPromotion(model: GiftCodeModel)
}

class ListPromotionVC: UIViewController {

    @IBOutlet weak var vSearch: UIView!
    @IBOutlet weak var tfSearch: UITextField!
    var delegate: SelectPromotionCallBackDelegate?
    private let tableView: UITableView = UITableView(frame: .zero, style: .grouped)
    private let viewModel: ListPromotionVM = ListPromotionVM()
    private var isFirstLoad: Bool = true
    @VariableReplay private var dataSource: [GiftCodeModel] = []
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
extension ListPromotionVC {
    private func visualize() {
        let buttonLeft = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
        buttonLeft.setImage(UIImage(named: "ic_arrow_left_black"), for: .normal)
        buttonLeft.contentEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        let leftBarButton = UIBarButtonItem(customView: buttonLeft)

        navigationItem.leftBarButtonItem = leftBarButton
        buttonLeft.rx.tap.bind { _ in
            self.navigationController?.popViewController()
        }.disposed(by: disposeBag)

        title = "Danh sách khuyến mãi"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                        NSAttributedString.Key.font: UIFont(name: "Montserrat-Medium", size: 15.0) ?? UIImage() ]
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "ColorApp")
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
        tableView.prefetchDataSource = self
        self.view.addSubview(self.tableView)
        tableView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(vLine.snp.bottom).inset(-63)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ListDiscountCell.nib, forCellReuseIdentifier: ListDiscountCell.identifier)
    }
    private func setupRX() {
        self.viewModel.getListAddressCallBack(text: "", page: self.currentPage)
        
        self.viewModel.indicator.asObservable().bind { (isLoad) in
            isLoad ? LoadingManager.instance.show() : LoadingManager.instance.dismiss()
        }.disposed(by: disposeBag)
                
        self.viewModel.$listPromotionCallBack.asObservable().bind(onNext: weakify({ (item, wSelf) in
            guard let item = item?.data else {
                return
            }
            wSelf.currentPage = 1
            wSelf.dataSource = item
            wSelf.tableView.scrollToTop()
            wSelf.isFirstLoad = false
            wSelf.tableView.reloadData()
        })).disposed(by: disposeBag)
        
        self.tfSearch.rx.text.orEmpty.asObservable()
            .debounce(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .bind(onNext: weakify({ (text, wSelf) in
                wSelf.currentPage = 1
                wSelf.viewModel.getListAddressCallBack(text: text, page: wSelf.currentPage)
            })).disposed(by: disposeBag)
    }
    private func requestData(currentPage: Int, text: String) {
        self.viewModel.getListDiscount(page: currentPage, text: text)
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
extension ListPromotionVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
}
extension ListPromotionVC: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let idx = indexPaths.last?.item else { return }
        let total = self.dataSource.count
        guard total - idx <= distanceItemRequest else { return }
        self.currentPage += 1
        requestData(currentPage: self.currentPage, text: self.tfSearch.text ?? "")
    }
}
extension ListPromotionVC: SkeletonTableViewDataSource {
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
        cell.lbTitle.text = element.giftCode
        cell.lbTimeApply.text = "Áp dụng từ ngày \(element.startDate ?? "") tới ngày \(element.endDate ?? "")"
        if let textUrl = element.imageUrl, let url = URL(string: textUrl) {
            cell.img.kf.setImage(with: url)
        }
        return cell
    }
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return ListDiscountCell.identifier
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.dataSource[indexPath.row]
        self.delegate?.selectPromotion(model: item)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
