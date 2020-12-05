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
}

class CategoryVC: UIViewController {
    
    var titleCate: String = ""
    @VariableReplay var categoryID: Int = 0
    var typeCategory: TypeCategory = .other
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var btFilter: UIButton!
    @IBOutlet weak var topProductContant: NSLayoutConstraint!
    private let vListCateView: CategoryListView = CategoryListView.loadXib()
    private var filter: PublishSubject<FilterMode> = PublishSubject.init()
    private let tap: UITapGestureRecognizer = UITapGestureRecognizer()
    private let viewModel: CategoryVM = CategoryVM()
    private var dataSource: [Product] = []
    private var dataSourceHot: [Product]?
    private let heightCell = 226
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
                                                                        NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 19.0) ?? UIImage() ]
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.emptyDataSetDelegate = self
        collectionView.emptyDataSetSource = self
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.register(ListCategoryCell.nib, forCellWithReuseIdentifier: ListCategoryCell.identifier)
        collectionView.register(HeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HeaderView.identifier)
        if categoryID != 4 {
            self.view.addSubview(self.vListCateView)
            self.vListCateView.snp.makeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.height.equalTo(50)
                make.bottom.equalTo(self.collectionView.snp.top)
            }
        } else {
            self.topProductContant.constant = 20
        }
        title = self.titleCate
        self.vListCateView.dataSource = ListProductStream.share.listCategory
        self.vListCateView.mSelectCategoryID = self.categoryID
        tap.cancelsTouchesInView = false
        self.collectionView.addGestureRecognizer(tap)
    }
    private func setupRX() {
        let combineID = Observable.merge(self.vListCateView.selectCategoryID.asObservable(), self.$categoryID.asObservable())
        Observable.combineLatest(combineID,self.filter.startWith(FilterMode()).asObservable()).bind { [weak self] (id, filter) in
            guard let wSelf = self else {
                return
            }
            guard filter.minPrice != nil else {
                wSelf.getListCate(id: id)
                return
            }
            guard var list = ListProductStream.share.getListProductWithCaterogy(categoryID: id),
                  var listHot = ListProductStream.share.getListCategoryHotProduct(categoryID: id) else {
                return
            }
            let viewAll = 4
            if id == viewAll {
                list = ListProductStream.share.getAllProduct()
                listHot = ListProductStream.share.getListAllHotProduct()
            }
            wSelf.dataSource = wSelf.viewModel.filterMode(list: list, filter: filter)
            wSelf.dataSourceHot = wSelf.viewModel.filterMode(list: listHot, filter: filter)
            wSelf.collectionView.reloadData()
        }.disposed(by: disposeBag)
        
        let combineList = Observable
            .combineLatest(combineID, self.filter.startWith(FilterMode()).asObservable())
        self.tfSearch.rx.text.orEmpty.withLatestFrom(combineList) { (text, combine) -> (Int, FilterMode, String) in
            return (combine.0, combine.1, text)
        }.bind { [weak self] (id, filter, textSearch) in
            guard let wSelf = self else {
                return
            }
            guard var list = ListProductStream.share.getListProductWithCaterogy(categoryID: id),
                  var listHot = ListProductStream.share.getListCategoryHotProduct(categoryID: id) else {
                return
            }
            let viewAll = 4
            if id == viewAll {
                list = ListProductStream.share.getAllProduct()
                listHot = ListProductStream.share.getListAllHotProduct()
            }
            guard !textSearch.isEmpty, textSearch != "" else {
                wSelf.dataSource = wSelf.viewModel.filterMode(list: list, filter: filter)
                wSelf.dataSourceHot = wSelf.viewModel.filterMode(list: listHot, filter: filter)
                wSelf.collectionView.reloadData()
                return
            }
            wSelf.dataSource = wSelf.viewModel.searchAndFilterMode(list: list, filter: filter, textSearch: textSearch)
            wSelf.dataSourceHot = wSelf.viewModel.searchAndFilterMode(list: listHot, filter: filter, textSearch: textSearch)
            wSelf.collectionView.reloadData()
        }.disposed(by: disposeBag)
        
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
        let viewAll = 4
        guard id != viewAll else {
            self.getAllProduct()
            return
        }
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
        if row % 2 != 0 {
            cell.rightArea.constant = 20
            cell.leftArea.constant = 0
        } else {
            cell.rightArea.constant = 0
            cell.leftArea.constant = 20
        }
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
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath) as! HeaderView
            headerView.visualize(list: self.dataSourceHot )
            headerView.viewHotProduct.didSelectIndex = { [weak self] id in
                self?.moveToProductDetail(id: id)
            }
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
    private func moveToProductDetail(id: Int) {
        let vc = ProductDetail(nibName: "ProductDetail", bundle: nil)
        vc.produceID = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension CategoryVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 280)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spaceLeftRight = 10
        return CGSize(width: (Int(self.view.bounds.width) - spaceLeftRight) / 2, height: heightCell)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let id = self.dataSource[indexPath.row].id {
            self.moveToProductDetail(id: id)
        }
    }
}
extension CategoryVC: FilterDelegate {
    func filterProduct(filter: FilterMode) {
        self.filter.onNext(filter)
    }
}
extension CategoryVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "Hiện tại chưa có sản phẩm"
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                   NSAttributedString.Key.font: UIFont.systemFont(ofSize: 19) ]
        let t = NSAttributedString(string: text, attributes: titleTextAttributes)
        return t
    }
}
