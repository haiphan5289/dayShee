//
//  HomeVC.swift
//  SnapChat
//
//  Created by admin on 5/5/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

enum HomeDisplayType: Int, CaseIterable {
    case banner
    case category
    case trademark
    case hotProducts
    case discountProduct
    
    var title: String {
        switch self {
        case .banner:
            return "Banner"
        case .trademark:
            return "Thương hiệu"
        case .category:
            return "Danh mục"
        case .hotProducts:
            return "Sản phẩm nổi bật"
        case . discountProduct:
            return "Sản phẩm khuyến mãi "
        }
    }
}

class HomeVC: BaseHiddenNavigationController {
    @IBOutlet weak var btFilter: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tfSearch: UITextField!
    private var listBanner: [Banner] = []
    private var listCategory: [CategoryHome] = []
    private var listHotProduct: [Product] = []
    private var listDiscountProduct: [Product] = []
    private var listProduct: [Product] = []
    private var viewModel: HomeViewModel = HomeViewModel()
    private var filter: PublishSubject<FilterMode> = PublishSubject.init()
    private let tap: UITapGestureRecognizer = UITapGestureRecognizer()
    private let tapTfSearch: UITapGestureRecognizer = UITapGestureRecognizer()
    private let disposeBag = DisposeBag()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        visualize()
        setupRX()
    }
}
extension HomeVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if self.listHotProduct.count > 0 {
            count += 1
        }
        if self.listDiscountProduct.count > 0 {
            count += 1
        }
        return 3 + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BannerView.identifier) as? HomeCellGeneric<BannerView>  else {
                fatalError("Please Implement")
            }
            cell.view.setupDisplay(item: self.listBanner)
            cell.view.didSelectIndex = { item in
                self.moveToBanner(item: item)
            }
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CatelogyView.identifier) as? HomeCellGeneric<CatelogyView>  else {
                fatalError("Please Implement")
            }
            cell.view.setupDisplay(item: self.listCategory)
            cell.view.updateHeightCell(table: self.tableView, count: self.listCategory.count)
            cell.view.didSelectIndex = { (categoryID, title) in
                self.moveToCategory(categoryID: categoryID, title: title)
            }
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TradeMarkView.identifier) as? HomeCellGeneric<TradeMarkView>  else {
                fatalError("Please Implement")
            }
            cell.view.setupDisplay(item: self.listProduct)
            cell.view.setupUI(title: "Thương hiệu", hidenImage: false)
            cell.view.updateHeightCell(table: self.tableView, count: listHotProduct.count)
            cell.view.didSelectIndex = { id in
                self.moveToProductDetail(id: id)
            }
            cell.view.selectViewAll = {
                self.moveToCategoryWithAll()
            }
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductView.identifier) as? HomeCellGeneric<ProductView>  else {
                fatalError("Please Implement")
            }
            cell.view.setupDisplay(item: self.listHotProduct)
            cell.view.setupUI(title: "Sản phẩm nổi bật", hidenImage: true)
            cell.view.updateHeightCell(table: self.tableView, count: self.listHotProduct.count)
            cell.view.didSelectIndex = { id in
                self.moveToProductDetail(id: id)
            }
            cell.view.selectViewAll = {
                self.moveToCategoryWithAll()
            }
            return cell
        case 4:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductView.identifier) as? HomeCellGeneric<ProductView>  else {
                fatalError("Please Implement")
            }
            cell.view.setupDisplay(item: self.listDiscountProduct)
            cell.view.setupUI(title: "Sản phẩm khuyến mãi", hidenImage: false)
            cell.view.updateHeightCell(table: self.tableView, count: self.listDiscountProduct.count)
            cell.view.didSelectIndex = { id in
                self.moveToProductDetail(id: id)
            }
            cell.view.selectViewAll = {
                self.moveToCategoryWithAll()
            }
            return cell
        default:
            fatalError("Please Implement")
        }
    }
}
extension HomeVC {
    private func visualize() {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -20)
        tableView.delegate = self
        tableView.dataSource = self
        HomeDisplayType.allCases.forEach { (type) in
            switch type {
            case .banner:
                tableView.register(HomeCellGeneric<BannerView>.self, forCellReuseIdentifier: BannerView.identifier)
            case .category:
                tableView.register(HomeCellGeneric<CatelogyView>.self, forCellReuseIdentifier: CatelogyView.identifier)
            case .trademark:
                tableView.register(HomeCellGeneric<TradeMarkView>.self, forCellReuseIdentifier: TradeMarkView.identifier)
            case .discountProduct, .hotProducts:
                tableView.register(HomeCellGeneric<ProductView>.self, forCellReuseIdentifier: ProductView.identifier)
            }
        }
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                                        NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 19.0) ?? UIImage() ]
        
        tap.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(tap)
        
        tapTfSearch.cancelsTouchesInView = true
        self.tfSearch.addGestureRecognizer(tapTfSearch)
    }
    private func setupRX() {
        self.viewModel.getListBanner()
        self.viewModel.getListCategory()
        self.viewModel.getProduct()
        self.viewModel.getListTradeMark()
        
        self.viewModel.indicator.asObservable().bind(onNext: { (item) in
            item ? LoadingManager.instance.show() : LoadingManager.instance.dismiss()
        }).disposed(by: disposeBag)
        
        
        self.viewModel.listBanner.asObservable().bind(onNext: weakify({ (list, wSelf) in
            wSelf.listBanner = list
            wSelf.tableView.reloadData()
        })).disposed(by: disposeBag)
        
        
        self.viewModel.listCategory.asObservable().bind(onNext: weakify({ (list, wSelf) in
            wSelf.listCategory = list
            wSelf.tableView.reloadData()
            ListProductStream.share.listCategory = list
        })).disposed(by: disposeBag)
        
        let triggerSearch: BehaviorRelay<Void> = BehaviorRelay.init(value: ())
        Observable.combineLatest(self.viewModel.listProduct.asObservable(),
                                 self.filter.startWith(FilterMode()).asObservable(),
                                 triggerSearch)
            .asObservable()
            .bind(onNext: weakify({ (item, wSelf) in
                guard let list = item.0.data else {
                    return
                }
                guard (item.1.minPrice == nil) else {
                    wSelf.listDiscountProduct = wSelf.viewModel.fillterListDiscount(list: list, filter: item.1)
                    wSelf.listHotProduct = wSelf.viewModel.filterListHotProduct(list: list, filter: item.1)
                    wSelf.listProduct = wSelf.viewModel.listTradeMarkFilter(list: list, filter: item.1)
                    wSelf.tableView.reloadData()
                    return
                }
                wSelf.listProduct = list
                wSelf.listHotProduct = list.filter { $0.isHot == true }
                wSelf.listDiscountProduct = wSelf.viewModel.listDiscount(list: list)
                wSelf.tableView.reloadData()
                ListProductStream.share.totalProduct = item.0
            })).disposed(by: disposeBag)
        
        self.viewModel.err
            .asObservable().bind(onNext: weakify({ (err, wSelf) in
                wSelf.showAlert(title: "Thông báo", message: err.message)
            })).disposed(by: disposeBag)
        
        self.btFilter.rx.tap.bind { _ in
            let vc = FillterVC(nibName: "FillterVC", bundle: nil)
            vc.hidesBottomBarWhenPushed = true
            vc.delegate = self
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }.disposed(by: disposeBag)
        
        self.tapTfSearch.rx.event.asObservable().bind(onNext: weakify({ (tap, wSelf) in
            let first = self.listCategory.first
            guard let id = first?.id, let title = first?.category else {
                return
            }
            wSelf.moveToCategory(categoryID: id, title: title)
        })).disposed(by: disposeBag)
        
        self.tap.rx.event.bind { _ in
            self.view.endEditing(true)
        }.disposed(by: disposeBag)
    }
    private func moveToBanner(item: Banner) {
        let vc = BannerVC(nibName: "BannerVC", bundle: nil)
        vc.hidesBottomBarWhenPushed = true
        vc.item = item
        self.navigationController?.pushViewController(vc, animated: true)
    }
    private func moveToProductDetail(id: Int) {
        let vc = ProductDetail(nibName: "ProductDetail", bundle: nil)
        vc.produceID = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    private func moveToCategory(categoryID: Int, title: String) {
        let vc = CategoryVC(nibName: "CategoryVC", bundle: nil)
        vc.categoryID = categoryID
        vc.titleCate = title
        self.navigationController?.pushViewController(vc, animated: true)
    }
    private func moveToCategoryWithAll() {
        let vc = CategoryVC(nibName: "CategoryVC", bundle: nil)
        vc.categoryID = 4
        vc.titleCate = "Sản phẩm"
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
}
extension HomeVC: FilterDelegate {
    func filterProduct(filter: FilterMode) {
        self.filter.onNext(filter)
    }
}

