//
//  ProductDetail.swift
//  Dayshee
//
//  Created by haiphan on 11/8/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ProductDetail: UIViewController {
    
    private let tableView: UITableView = UITableView(frame: .zero, style: .grouped)
    var produceID: Int?
    private var item: HomeDetailModel?
    private var viewModel: ProductDetailVM = ProductDetailVM()
    private var totalCell = 1
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
extension ProductDetail {
    private func visualize() {
        //        self.tableView.isHidden = true
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
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        self.view.addSubview(self.tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProductDetailCell.nib, forCellReuseIdentifier: ProductDetailCell.identifier)
        tableView.register(HomeCellGeneric<PDProduct>.self, forCellReuseIdentifier: PDProduct.identifier)
    }
    private func setupRX() {
        self.viewModel.getDetailProduct(id: self.produceID ?? 0)
        
        self.viewModel.indicator.asObservable().bind(onNext: { (item) in
            item ? LoadingManager.instance.show() : LoadingManager.instance.dismiss()
        }).disposed(by: disposeBag)
        
        self.viewModel.$dataSource.asObservable().bind(onNext: weakify({ (item, wSelf) in
            wSelf.item = item
            wSelf.tableView.reloadData()
        })).disposed(by: disposeBag)
        
        self.viewModel.$err.asObservable().bind(onNext: weakify({ (err, wSelf) in
            wSelf.showAlert(title: "Thông báo", message: err.message)
        })).disposed(by: disposeBag)
    }
}
extension ProductDetail: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var total = 0
        if let relate = self.item?.relatedProducts, relate.count > 0 {
            total += 1
        }
        if let l = ListProductStream.share.getListProductTheSameTradeMark(tradeMarkID: self.item?.trademarkID ?? 0), l.count > 0 {
            total += 1
        }
        return totalCell + total
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row  {
        case 1:
            guard let relate = self.item?.relatedProducts, relate.count > 0 else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: PDProduct.identifier) as? HomeCellGeneric<PDProduct> else {
                    fatalError("Not implement")
                }
                cell.view.setupUI(title: "Sản phẩm cùng thương hiệu" )
                let list = ListProductStream.share.getListProductTheSameTradeMark(tradeMarkID: self.item?.trademarkID ?? 0)
                cell.view.setupDisplay(item: list)
                cell.view.didSelectIndex = { [weak self] id in
                    self?.moveToProductDetail(id: id)
                }
                return cell
            }
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PDProduct.identifier) as? HomeCellGeneric<PDProduct> else {
                fatalError("Not implement")
            }
            cell.view.setupUI(title: "Sản phẩm mua kèm" )
            cell.view.setupDisplay(item: relate)
            cell.view.didSelectIndex = { [weak self] id in
                self?.moveToProductDetail(id: id)
            }
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PDProduct.identifier) as? HomeCellGeneric<PDProduct> else {
                fatalError("Not implement")
            }
            cell.view.setupUI(title: "Sản phẩm cùng thương hiệu" )
            let list = ListProductStream.share.getListProductTheSameTradeMark(tradeMarkID: self.item?.trademarkID ?? 0)
            cell.view.setupDisplay(item: list)
            cell.view.didSelectIndex = { [weak self] id in
                self?.moveToProductDetail(id: id)
            }
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductDetailCell.identifier) as? ProductDetailCell else {
                fatalError("Not implement")
            }
            cell.vImage.setupDisplay(item: self.item)
            cell.vImage.addCart = { (item, count) in
                RealmManager.shared.insertOrUpdateProduct(model: item, count: count)
                self.showAlert(title: nil, message: "Bạn đã thêm vào giỏ hàng")
            }
            cell.vImage.btShareSelect = { [weak self] in
                guard  let wSelf = self else {
                    return
                }
                let message = "Dayshee...."
                let url = "https://dayshee.com/san-pham/\(wSelf.item?.slug ?? "").html"
                if let link = NSURL(string: url)
                {
                    let objectsToShare: [Any] = [message,link]
                    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                    activityVC.excludedActivityTypes = [.airDrop, .addToReadingList, .assignToContact,
                                                        .mail, .message, .postToFacebook, .postToWhatsApp]
                    wSelf.present(activityVC, animated: true, completion: nil)
                }
            }
            
            cell.vDetail.setupDisplay(item: self.item)
            cell.vDetail.updateCell = {
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }
            cell.vDetail.moveToQA = {
                let vc = QuestionVC(nibName: "QuestionVC", bundle: nil)
                vc.hidesBottomBarWhenPushed = true
                vc.id = self.item?.id
                self.navigationController?.pushViewController(vc, animated: true)
            }
            cell.vDetail.moveToListFAQ = { list in
                let vc = ListFAQVC(nibName: "ListFAQVC", bundle: nil)
                vc.hidesBottomBarWhenPushed = true
                vc.list = list
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            if let listComment = self.item?.productRatings {
                if listComment.count > 0 {
                    cell.addViewComment()
                }
            }
            cell.vComment.setupDisplay(item: self.item)
            cell.vComment.updateHeight = {
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }
            cell.vComment.moveToListRating = { list in
                let vc = ListRatingVC(nibName: "ListRatingVC", bundle: nil)
                vc.hidesBottomBarWhenPushed = true
                vc.list = list
                self.navigationController?.pushViewController(vc, animated: true)
            }
            cell.vComment.moveToRate = { productID in
                let vc = RateVC(nibName: "RateVC", bundle: nil)
                vc.productID = productID
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        }
    }
    private func moveToProductDetail(id: Int) {
        let vc = ProductDetail(nibName: "ProductDetail", bundle: nil)
        vc.produceID = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension ProductDetail: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1000
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}
