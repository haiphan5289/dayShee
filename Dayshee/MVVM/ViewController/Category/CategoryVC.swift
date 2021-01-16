//
//  CategoryVC.swift
//  Dayshee
//
//  Created by haiphan on 11/7/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import DZNEmptyDataSet

enum TypeCategory {
    case viewAll
    case other
    case hotProduct
    case discount
}

class CategoryVC: UIViewController {
    
    var titleCate: String = ""
    @VariableReplay var categoryID: Int = 0
    var typeCategory: TypeCategory = .other
    var p: [String: Any] = [:]
    var typeRouterFilter: RouterFilter = .search
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var btFilter: UIButton!
    @IBOutlet weak var topProductContant: NSLayoutConstraint!
    private let vListCateView: CategoryListView = CategoryListView.loadXib()
    @Replay(queue: MainScheduler.asyncInstance) var filter: FilterMode
    private let tap: UITapGestureRecognizer = UITapGestureRecognizer()
    private let viewModel: CategoryVM = CategoryVM()
    private var dataSource: [Product] = []
    private var parameters: [String: Any] = [:]
    private var dataSourceHot: [Product]?
    private var currentPage: Int = 1
    private var distanceItemRequest = 5
    {
        didSet {
            assert(distanceItemRequest >= 0, "Check !!!!!!")
        }
    }
    private let heightCell = 246
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.visualize()
        self.setupRX()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
extension CategoryVC {
    private func visualize() {
        let buttonLeft = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
        buttonLeft.setImage(UIImage(named: "ic_arrow_left_black"), for: .normal)
        buttonLeft.contentEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        let leftBarButton = UIBarButtonItem(customView: buttonLeft)
        
        navigationItem.leftBarButtonItem = leftBarButton
        buttonLeft.rx.tap.bind { _ in
            self.navigationController?.popViewController()
        }.disposed(by: disposeBag)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                                        NSAttributedString.Key.font: UIFont(name: "Montserrat-Medium", size: 15) ?? UIImage() ]
        self.navigationController?.navigationBar.barTintColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.emptyDataSetDelegate = self
        collectionView.emptyDataSetSource = self
        collectionView.prefetchDataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.register(ListCategoryCell.nib, forCellWithReuseIdentifier: ListCategoryCell.identifier)
        collectionView.register(HeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HeaderView.identifier)
        switch typeCategory {
        case .discount, .hotProduct:
            self.topProductContant.constant = 20
            self.title = (self.typeCategory == .hotProduct) ? "Sản phẩm nổi bật" : "Sản phẩm khuyến mãi"
        default:
            self.view.addSubview(self.vListCateView)
            self.vListCateView.snp.makeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.height.equalTo(50)
                make.bottom.equalTo(self.collectionView.snp.top)
            }
            title = self.titleCate
        }
        self.vListCateView.dataSource = ListProductStream.share.listCategory
        self.vListCateView.mSelectCategoryID = self.categoryID
        tap.cancelsTouchesInView = false
        self.collectionView.addGestureRecognizer(tap)
    }
    private func setupRX() {
        if self.typeRouterFilter == .search {
            self.parameters = p
            self.viewModel.getCateloryWithFilter(p: p, page: self.currentPage)
            let f = FilterMode()
            self.filter = f
        }
        
        self.viewModel.indicator.asObservable().bind(onNext: { (item) in
            item ? LoadingManager.instance.show() : LoadingManager.instance.dismiss()
        }).disposed(by: disposeBag)
        
        self.viewModel.$listProduct.asObservable()
            .bind(onNext: weakify({ (item, wSelf) in
                guard let list = item.data else {
                    return
                }
                wSelf.dataSource = list
                wSelf.collectionView.reloadData()
            })).disposed(by: disposeBag)
        
        let combineID = Observable.merge(self.vListCateView.selectCategoryID.asObservable(),
                                         self.$categoryID.asObservable())
        let textSearch = self.tfSearch.rx.text.map { $0 }
            .debounce(.seconds(1), scheduler: MainScheduler.asyncInstance)
        Observable.combineLatest(combineID, self.$filter.asObservable(),textSearch)
            .bind { [weak self] (id, filter, text) in
                guard let wSelf = self else {
                    return
                }
                var p: [String: Any] = [:]
                p["category_id"] = id
                p["key_word"] = text
                guard filter.minPrice != nil else {
                    wSelf.parameters = p
                    wSelf.viewModel.getCateloryWithFilter(p: p, page: wSelf.currentPage)
                    return
                }
                if let minPrice = filter.minPrice {
                    p["min_price"] = minPrice
                }
                if let maxPrice = filter.maxPrice {
                    p["max_price"] = maxPrice
                }
                wSelf.parameters = p
                wSelf.viewModel.getCateloryWithFilter(p: p, page: wSelf.currentPage)
                //            ListProductStream.share.listCategory.forEach { (c) in
                //                if c.id == id && wSelf.typeCategory != .discount && wSelf.typeCategory != .hotProduct {
                //                    wSelf.title = c.category
                //                }
                //            }
                //            guard filter.minPrice != nil else {
                //                wSelf.getListCate(id: id)
                //                return
                //            }
                //            guard var list = ListProductStream.share.getListProductWithCaterogy(categoryID: id),
                //                  let listHot = ListProductStream.share.getListCategoryHotProduct(categoryID: id) else {
                //                return
                //            }
                //            switch wSelf.typeCategory {
                //            case .hotProduct:
                //                list = ListProductStream.share.getListAllHotProduct()
                //            case .discount:
                //                list = ListProductStream.share.listDiscount()
                //            default:
                //                break
                //            }
                //            wSelf.dataSource = wSelf.viewModel.filterMode(list: list, filter: filter)
                //            wSelf.dataSourceHot = wSelf.viewModel.filterMode(list: listHot, filter: filter)
                //            wSelf.collectionView.reloadData()
            }.disposed(by: disposeBag)
        
        //        let combineList = Observable
        //            .combineLatest(combineID, self.$filter.asObservable())
        //        self.tfSearch.rx.text.orEmpty.withLatestFrom(combineList) { (text, combine) -> (Int, FilterMode, String) in
        //            return (combine.0, combine.1, text)
        //        }.bind { [weak self] (id, filter, textSearch) in
        //            guard let wSelf = self else {
        //                return
        //            }
        //            guard filter.minPrice != nil else {
        //                var p: [String: Any] = ["category_id": id]
        //                p["key_word"] = "\(textSearch)"
        //                wSelf.viewModel.getCateloryWithFilter(p: p)
        //                return
        //            }
        //            var p: [String: Any] = ["category_id": id]
        //            if let minPrice = filter.minPrice {
        //                p["min_price"] = minPrice
        //            }
        //            if let maxPrice = filter.maxPrice {
        //                p["max_price"] = maxPrice
        //            }
        //            p["key_word"] = "\(textSearch)"
        //            wSelf.viewModel.getCateloryWithFilter(p: p)
        ////            guard var list = ListProductStream.share.getListProductWithCaterogy(categoryID: id),
        ////                  let listHot = ListProductStream.share.getListCategoryHotProduct(categoryID: id) else {
        ////                return
        ////            }
        ////            switch wSelf.typeCategory {
        ////            case .hotProduct:
        ////                list = ListProductStream.share.getListAllHotProduct()
        ////            case .discount:
        ////                list = ListProductStream.share.listDiscount()
        ////            default:
        ////                break
        ////            }
        ////            guard !textSearch.isEmpty, textSearch != "" else {
        ////                wSelf.dataSource = wSelf.viewModel.filterMode(list: list, filter: filter)
        ////                wSelf.dataSourceHot = wSelf.viewModel.filterMode(list: listHot, filter: filter)
        ////                wSelf.collectionView.reloadData()
        ////                return
        ////            }
        ////            wSelf.dataSource = wSelf.viewModel.searchAndFilterMode(list: list, filter: filter, textSearch: textSearch)
        ////            wSelf.dataSourceHot = wSelf.viewModel.searchAndFilterMode(list: listHot, filter: filter, textSearch: textSearch)
        ////            wSelf.collectionView.reloadData()
        //        }.disposed(by: disposeBag)
        
        self.btFilter.rx.tap.bind { _ in
            let vc = FillterVC(nibName: "FillterVC", bundle: nil)
            vc.hidesBottomBarWhenPushed = true
            vc.delegate = self
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }.disposed(by: disposeBag)
        
        self.tap.rx.event.bind { _ in
            self.view.endEditing(true)
        }.disposed(by: disposeBag)
    }
    private func getListCate(id: Int) {
        guard let list = ListProductStream.share.getListProductWithCaterogy(categoryID: id) else {
            return
        }
        self.dataSource = list
        self.dataSourceHot = ListProductStream.share.getListCategoryHotProduct(categoryID: id)
        self.collectionView.reloadData()
    }
    private func getAllProduct() {
        let list = ListProductStream.share.getAllProduct()
        self.dataSource = list
        self.dataSourceHot = ListProductStream.share.getListAllHotProduct()
        self.collectionView.reloadData()
    }
    private func setupUICell(cell: ListCategoryCell, row: Int) {
        //        if row % 2 != 0 {
        //            cell.rightArea.constant = 20
        //            cell.leftArea.constant = 0
        //        } else {
        //            cell.rightArea.constant = 0
        //            cell.leftArea.constant = 20
        //        }
    }
}
extension CategoryVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCategoryCell.identifier, for: indexPath) as? ListCategoryCell else {
            fatalError("")
        }
        let data = self.dataSource[indexPath.row]
        cell.lbPrice.text = data.maxPrice?.currency
        cell.lbPriceDiscount.text = data.minPrice?.currency
        cell.lbName.text = data.name ?? ""
        self.setupUICell(cell: cell, row: indexPath.row)
        if let textUrl = data.imageURL, let url = URL(string: textUrl)  {
            cell.imgProduct.kf.setImage(with: url)
        }
        return cell
    }
    //    func collectionView(_ collectionView: UICollectionView,
    //                        viewForSupplementaryElementOfKind kind: String,
    //                        at indexPath: IndexPath) -> UICollectionReusableView {
    //        switch kind {
    //        case UICollectionView.elementKindSectionHeader:
    //            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath) as! HeaderView
    //            headerView.visualize(list: self.dataSourceHot )
    //            headerView.viewHotProduct.didSelectIndex = { [weak self] id in
    //                self?.moveToProductDetail(id: id)
    //            }
    //            return headerView
    //        default:
    //            assert(false, "Unexpected element kind")
    //        }
    //    }
    private func moveToProductDetail(id: Int) {
        let vc = ProductDetail(nibName: "ProductDetail", bundle: nil)
        vc.produceID = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    private func requestData(currentPage: Int, p: [String: Any]) {
        self.viewModel.getCateloryWithFilterCallBack(page: currentPage, p: p)
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
                    wSelf.collectionView.reloadData()
                case .failure(let err):
                    self?.showAlert(title: nil, message: err.message)
                }
            }).disposed(by: disposeBag)
    }
}

extension CategoryVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    //        if self.typeCategory == .hotProduct || self.typeCategory == .discount {
    //            return CGSize(width: 0, height: 0)
    //        }
    //        return CGSize(width: collectionView.frame.width, height: 280)
    //    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spaceLeftRight = 10
        return CGSize(width: (Int(self.view.bounds.width) - spaceLeftRight) / 2, height: heightCell)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let id = self.dataSource[indexPath.row].id {
            self.moveToProductDetail(id: id)
        }
    }
}
extension CategoryVC: FilterDelegate {
    func filterProduct(filter: FilterMode?) {
        if let filter = filter {
            self.filter = filter
        }
    }
}
extension CategoryVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "Hiện tại chưa có sản phẩm"
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                   NSAttributedString.Key.font: UIFont(name: "Montserrat-Medium", size: 15) ]
        let t = NSAttributedString(string: text, attributes: titleTextAttributes as [NSAttributedString.Key : Any])
        return t
    }
}
extension CategoryVC: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let idx = indexPaths.last?.item else { return }
        let total = self.dataSource.count
        guard total - idx <= distanceItemRequest else { return }
        self.currentPage += 1
        requestData(currentPage: self.currentPage, p: self.parameters)
    }
}
