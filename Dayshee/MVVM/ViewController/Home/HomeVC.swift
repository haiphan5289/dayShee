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

enum AddCategory: Int, CaseIterable {
    case gift = -2
    case agency = -3
    case contact = -1
    case messenger = -4
    case zalo = -5
    case zaloFb = 99
    
    var text: String {
        switch self {
        case .gift:
            return "Quà tặng"
        case .agency:
            return "Đại lý"
        case .contact:
            return "Liên hệ"
        default:
            return ""
        }
    }
    
    var imgStr: String {
        switch self {
        case .agency:
            return "https://api.dayshee.com/images/icons/agency.png"
        case .contact:
            return "https://api.dayshee.com/images/icons/contact.png"
        case .gift:
            return "https://api.dayshee.com/images/icons/gift.png"
        default:
            return ""
        }
    }
    
    var id: Int {
        switch self {
        case .agency:
           return -2
        case .contact:
            return -3
        case .gift:
            return -1
        case .messenger:
            return -4
        case .zalo:
            return -5
        case .zaloFb:
            return 99
        }
    }
}

enum HomeDisplayType: Int, CaseIterable {
    case banner
    case category
    case trademark
    case hotProducts
    case discountProduct
    case search
    case bannerAdv
    
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
        case .search:
            return "Tìm kiếm"
        case .bannerAdv:
            return "Quảng cáo"
        }
    }
}

class HomeVC: BaseHiddenNavigationController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vHeader: UIView!
    @IBOutlet weak var topTableView: NSLayoutConstraint!
    lazy private var vPopup: PopupView = PopupView.loadXib()
    lazy private var vLocation: LocationView = LocationView.loadXib()
    private var filter: FilterMode?
    private var listBanner: [Banner] = []
    private var listBannerFooter: BannerAdv?
    private var listCategory: [ProductHomeModel] = []
    private var viewModel: HomeViewModel = HomeViewModel()
    private var listProductHome: [ProductHomeModel] = []
    private let tap: UITapGestureRecognizer = UITapGestureRecognizer()
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
//        var count = 0
//        if self.listHotProduct.count > 0 {
//            count += 1
//        }
//        if self.listDiscountProduct.count > 0 {
//            count += 1
//        }
        return self.listProductHome.count + 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case self.listProductHome.count + 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BannerAdvView.identifier) as? HomeCellGeneric<BannerAdvView>  else {
                fatalError("Please Implement")      
            }
            cell.view.setupDisplay(item: self.listBannerFooter)
            cell.view.didSelectIndex = { item in
//                self.moveToBanner(item: nil, bannerAdv: item)
            }
            return cell
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BannerView.identifier) as? HomeCellGeneric<BannerView>  else {
                fatalError("Please Implement")
            }
            cell.view.setupDisplay(item: self.listBanner)
            cell.view.didSelectIndex = { [weak self] item in
                guard let wSelf = self else {
                    return
                }
                wSelf.selectBanner(item: item)
            }
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchView.identifier) as? HomeCellGeneric<SearchView>  else {
                fatalError("Please Implement")
            }
            cell.view.moveToCategory = {
                let first = self.listCategory.first
                guard let id = first?.id, let title = first?.category else {
                    return
                }
                self.moveToCategory(categoryID: id, title: title)
            }
            cell.view.filter = {
                let vc = FillterVC(nibName: "FillterVC", bundle: nil)
                vc.hidesBottomBarWhenPushed = true
                vc.type = .home
                let firstCate = self.listCategory.first
                vc.firstCategory = firstCate
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CatelogyView.identifier) as? HomeCellGeneric<CatelogyView>  else {
                fatalError("Please Implement")
            }
            cell.view.setupDisplay(item: self.listCategory)
            //Do'nt load Cell again
            if !cell.view.hasLoadData {
                cell.view.updateHeightCell(table: self.tableView, count: self.listCategory.count)
            }
            cell.view.didSelectIndex = { (categoryID, title) in
                self.moveToCategory(categoryID: categoryID, title: title)
            }
            return cell
//        case 2:
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: TradeMarkView.identifier) as? HomeCellGeneric<TradeMarkView>  else {
//                fatalError("Please Implement")
//            }
//            cell.view.setupDisplay(item: self.listProduct)
//            cell.view.setupUI(title: "Thương hiệu", hidenImage: false)
//            cell.view.updateHeightCell(table: self.tableView, count: listHotProduct.count)
//            cell.view.didSelectIndex = { id in
//                self.moveToProductDetail(id: id)
//            }
//            cell.view.selectViewAll = {
//                self.moveToCategoryWithAll(type: .viewAll)
//            }
//            return cell
//        case 1:
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductView.identifier) as? HomeCellGeneric<ProductView>  else {
//                fatalError("Please Implement")
//            }
//            cell.view.setupDisplay(item: self.listHotProduct)
//            cell.view.setupUI(title: "Sản phẩm nổi bật", hidenImage: true)
//            cell.view.updateHeightCell(table: self.tableView, count: self.listHotProduct.count)
//            cell.view.didSelectIndex = { id in
//                self.moveToProductDetail(id: id)
//            }
//            cell.view.selectViewAll = {
//                self.moveToCategoryWithAll(type: .hotProduct)
//            }
//            return cell
//        case 3:
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductView.identifier) as? HomeCellGeneric<ProductView>  else {
//                fatalError("Please Implement")
//            }
//            cell.view.setupDisplay(item: self.listDiscountProduct)
//            cell.view.setupUI(title: "Sản phẩm khuyến mãi", hidenImage: false)
//            cell.view.updateHeightCell(table: self.tableView, count: self.listDiscountProduct.count)
//            cell.view.didSelectIndex = { id in
//                self.moveToProductDetail(id: id)
//            }
//            cell.view.selectViewAll = {
//                self.moveToCategoryWithAll(type: .discount)
//            }
//            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductView.identifier) as? HomeCellGeneric<ProductView>  else {
                fatalError("Please Implement")
            }
            

//            if let f = self.filter {
////                if !cell.view.hasLoadData {
//                    self.viewModel.getProductFilter(id: itemCategory.id ?? 0, idx: indexPath, filter: f)
////                }
//            } else {
//                if !cell.view.hasLoadData {
////                    self.viewModel.getProduct(id: itemCategory.id ?? 0, idx: indexPath)
//                }
//            }
            let item = self.listProductHome[indexPath.row - 3]
            cell.view.setupUI(title: item.category ?? "", hidenImage: true, hotProducts: item.hotProducts ?? [])
            cell.view.setupDisplay(item: item.products)
            cell.view.updateHeightCell(table: self.tableView, count: item.products?.count ?? 0, item: item)
            cell.view.didSelectIndex = { id in
                self.moveToProductDetail(id: id)
            }
            cell.view.selectViewAll = {
//                self.moveToCategoryWithAll(type: .hotProduct)
                let vc = CategoryVC(nibName: "CategoryVC", bundle: nil)
                vc.typeCategory = .other
                vc.categoryID = item.id ?? 0
                vc.titleCate = item.category ?? ""
                let p: [String: Any] = ["category_id": item.id ?? 0]
                vc.p = p
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        }
    }
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let v: UIView = UIView()
//
//        let vBannerFooter: BannerView = BannerView.loadXib()
//        v.addSubview(vBannerFooter)
//        vBannerFooter.snp.makeConstraints { (make) in
//            make.left.top.bottom.equalToSuperview()
//            make.right.equalToSuperview().inset(20)
//        }
////        vBannerFooter.setupDisplay(item: self.listBannerFooter)
//        vBannerFooter.didSelectIndex = { item in
//            self.moveToBanner(item: item)
//        }
//
//        return v
//    }
}
extension HomeVC {
    private func visualize() {
        let topPadding = UIApplication.shared.keyWindow?.safeAreaInsets.top
        self.topTableView.constant = -(topPadding ?? 0)
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
            case .search:
                tableView.register(HomeCellGeneric<SearchView>.self, forCellReuseIdentifier: SearchView.identifier)
            case .bannerAdv:
                tableView.register(HomeCellGeneric<BannerAdvView>.self, forCellReuseIdentifier: BannerAdvView.identifier)
            }
        }
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                                        NSAttributedString.Key.font: UIFont(name: "Montserrat-SemiBold", size: 20) ?? UIImage() ]
        
        tap.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(tap)
        
        if !DataLocal.share.isFirstLocationView {
            self.view.addSubview(vLocation)
            vLocation.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            DataLocal.share.isFirstLocationView = true
        } else {
            self.viewModel.getListBannerPopup()
        }
        
    }
    private func setupRX() {
        self.viewModel.getListBanner()
        self.viewModel.getListCategory()
        self.viewModel.getListTradeMark()
        self.viewModel.getProduct()
        self.viewModel.getListBannerAdv()
        self.viewModel.checkLogin()
        
        if let list = RealmManager.shared.getListLocation(), list.count > 0 {
            self.vLocation.listLocation = list
        } else {
            self.viewModel.getLocaion()
        }
        
        self.viewModel.indicator.asObservable().bind(onNext: { (item) in
            item ? LoadingManager.instance.show() : LoadingManager.instance.dismiss()
        }).disposed(by: disposeBag)
        
        self.vLocation.actionStartOrder = { [weak self] item in
            guard let wSelf = self else {
                return
            }
            if wSelf.viewModel.isLogin {
                let p: [String: Any] = ["order_province_id": item.id ?? 0]
                wSelf.viewModel.updateProvince(p: p)
            } else {
                RealmManager.shared.insertOrUpdateCurrentLocation(model: item)
                DataLocal.share.isUpdateProvince = true
            }
            wSelf.vLocation.isHidden = true
            wSelf.viewModel.getListBannerPopup()
        }
        
        self.vLocation.btClose.rx.tap.bind { _ in
            self.vLocation.isHidden = true
            self.viewModel.getListBannerPopup()
        }.disposed(by: disposeBag)
        
        self.viewModel.location.asObservable().bind(onNext: weakify({ (data, wSelf) in
            wSelf.vLocation.listLocation = data
        })).disposed(by: disposeBag)
        
        self.viewModel.listBanner.asObservable().bind(onNext: weakify({ (list, wSelf) in
            wSelf.listBanner = list
            wSelf.tableView.reloadData()
        })).disposed(by: disposeBag)
        
        self.viewModel.listBannerAdv.asObservable().bind(onNext: weakify({ (list, wSelf) in
            wSelf.listBannerFooter = list
        })).disposed(by: disposeBag)
        
        self.viewModel.listBannerFooter.asObservable().bind(onNext: weakify({ (list, wSelf) in
            wSelf.view.addSubview(wSelf.vPopup)
            wSelf.vPopup.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            wSelf.vPopup.setupDisplay(item: list)
            wSelf.vPopup.closeView = {
                wSelf.vPopup.isHidden = true
            }
            wSelf.vPopup.didSelectIndex = { banner in
                wSelf.vPopup.isHidden = true
                wSelf.moveToProductDetail(id: banner.productID ?? 0)
            }
        })).disposed(by: disposeBag)
        
        self.viewModel.listProductCategory.asObservable().bind(onNext: weakify({ (item, wSelf) in
            wSelf.listCategory = item
            wSelf.listProductHome = item.filter({ (product) -> Bool in
                guard let products = product.products, products.count > 0 else {
                    return false
                }
                return true
            })
            ListProductStream.share.listCategory =  wSelf.listProductHome
            wSelf.tableView.reloadData()
        })).disposed(by: disposeBag)
                
//        let triggerSearch: BehaviorRelay<Void> = BehaviorRelay.init(value: ())
//        Observable.combineLatest(self.viewModel.listProduct.asObservable(),
//                                 self.filter.startWith(FilterMode()).asObservable(),
//                                 triggerSearch)
//            .asObservable()
//            .bind(onNext: weakify({ (item, wSelf) in
//                guard let list = item.0.data else {
//                    return
//                }
//                guard (item.1.minPrice == nil) else {
//                    wSelf.listDiscountProduct = wSelf.viewModel.fillterListDiscount(list: list, filter: item.1)
//                    wSelf.listHotProduct = wSelf.viewModel.filterListHotProduct(list: list, filter: item.1)
//                    wSelf.listProduct = wSelf.viewModel.listTradeMarkFilter(list: list, filter: item.1)
//                    wSelf.tableView.reloadData()
//                    return
//                }
//                wSelf.listProduct = list
//                wSelf.listHotProduct = list.filter { $0.isHot == true }
//                wSelf.listDiscountProduct = wSelf.viewModel.listDiscount(list: list)
//                wSelf.tableView.reloadData()
//                ListProductStream.share.totalProduct = item.0
//            })).disposed(by: disposeBag)
        
        self.viewModel.err
            .asObservable().bind(onNext: weakify({ (err, wSelf) in
                wSelf.showAlert(title: "Thông báo", message: err.message)
            })).disposed(by: disposeBag)
        
        self.tap.rx.event.bind { _ in
            self.view.endEditing(true)
        }.disposed(by: disposeBag)
    }
    private func selectBanner(item: Banner) {
        guard let productID = item.productID,  let type = item.type, let typeBanner = TypeBanner(rawValue: type) else {
            return
        }
        switch typeBanner {
        case .typeProduct:
            self.moveToProductDetail(id: productID)
        default:
            self.moveToBanner(item: item, bannerAdv: nil)
        }
        
    }
    private func moveToBanner(item: Banner?, bannerAdv: BannerAdv?) {
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
        switch categoryID {
        case AddCategory.zaloFb.rawValue:
            self.showAlert(type: .actionSheet,
                           title: nil, message: nil,
                           buttonTitles: ["Zalo", "Facebook"],
                           highlightedButtonIndex: nil) { (idx) in
                if idx == 0 {
                    UIApplication.shared.open(URL(string: "\(LINK_ZALO)")!,
                                              options: [:]) { _ in
                        
                    }
                } else {
                    if let url = URL(string: "\(LINK_MESSGER)\(ID_MESSGER)") {
                        UIApplication.shared.open(url, options: [:]) { (success) in
                            //
                        }
                    }
                }
            }
        case AddCategory.messenger.rawValue:
            if let url = URL(string: "\(LINK_MESSGER)\(ID_MESSGER)") {
                UIApplication.shared.open(url, options: [:]) { (success) in
                    //
                }
            }
            
        case AddCategory.zalo.rawValue:
            UIApplication.shared.open(URL(string: "\(LINK_ZALO)")!,
                                      options: [:]) { _ in
                
            }

        case AddCategory.agency.rawValue:
            let vc = ListAgency(nibName: "ListAgency", bundle: nil)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case AddCategory.gift.rawValue:
            let vc = ListDiscountVC(nibName: "ListDiscountVC", bundle: nil)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case AddCategory.contact.rawValue:
            self.showActionSheetContact()
        default:
            let vc = CategoryVC(nibName: "CategoryVC", bundle: nil)
            vc.typeCategory = .other
            vc.categoryID = categoryID
            vc.titleCate = title
            let p: [String: Any] = ["category_id": categoryID]
            vc.p = p
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    private func showActionSheetContact() {
        self.showAlert(type: .actionSheet,
                       title: nil, message: nil, buttonTitles: ["Liên hệ", "Zalo", "Facebook"],
                       highlightedButtonIndex: nil) { (idx) in
            switch idx {
            case 0:
                let vc = ContactVC(nibName: "ContactVC", bundle: nil)
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            case 1:
                UIApplication.shared.open(URL(string: "\(LINK_ZALO)")!,
                                          options: [:]) { _ in
                    
                }
            case 2:
                if let url = URL(string: "\(LINK_MESSGER)\(ID_MESSGER)") {
                    UIApplication.shared.open(url, options: [:]) { (success) in
                        //
                    }
                }
            default:
                break
            }
        }
    }
    private func moveToCategoryWithAll(type: TypeCategory) {
        let vc = CategoryVC(nibName: "CategoryVC", bundle: nil)
        vc.typeCategory = type
        vc.categoryID = 1
        vc.titleCate = "Mặt nạ"
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

