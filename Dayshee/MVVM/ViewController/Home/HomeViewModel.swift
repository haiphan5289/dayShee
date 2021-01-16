//
//  HomeViewModel.swift
//  Dayshee
//
//  Created by haiphan on 11/5/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import RxSwift
import RxCocoa

class HomeViewModel: ActivityTrackingProgressProtocol {
    var listBanner: PublishSubject<[Banner]> = PublishSubject.init()
    var listBannerFooter: PublishSubject<[Banner]> = PublishSubject.init()
    var listBannerAdv: PublishSubject<BannerAdv> = PublishSubject.init()
    var listCategory: PublishSubject<[CategoryHome]> = PublishSubject.init()
//    var listProduct: PublishSubject<ProductHome> = PublishSubject.init()
    var location: PublishSubject<[Location]> = PublishSubject.init()
    var listProductCategory: PublishSubject<[ProductHomeModel]> = PublishSubject.init()
    var listProductFilter: PublishSubject<ProductHome> = PublishSubject.init()
    var listTrademark: PublishSubject<[Trademark]> = PublishSubject.init()
    @VariableReplay var isLogin: Bool = false
    @Replay(queue: MainScheduler.asyncInstance) var updateProvince: ProvinceOrderModel
    var listHotProduct: [Product]?
    var err: PublishSubject<ErrorService> = PublishSubject.init()
    private let disposeBag = DisposeBag()
    
    func getLocaion() {
        RequestService.shared.APIData(ofType: OptionalMessageDTO<[Location]>.self,
                                      url: APILink.location.rawValue,
                                      parameters: nil,
                                      method: .get)
            .trackProgressActivity(self.indicator)
            .bind { (result) in
                switch result {
                case .success(let value):
                    guard let data = value.data, let model = data else {
                        return
                    }
                    self.location.onNext(model)
                    self.insertRealm(items: model)
                case .failure(let err):
                    self.err.onNext(err)
                }}.disposed(by: disposeBag)
    }
    
    private func insertRealm(items: [Location]) {
        items.forEach { (value) in
            let v = LocationRealm(model: value)
            RealmManager.shared.insertLocation(item: v)
        }
    }
    
    func getListTradeMark() {
        RequestService.shared.APIData(ofType: OptionalMessageDTO<[Trademark]>.self,
                                      url: APILink.tradeMark.rawValue,
                                      parameters: nil,
                                      method: .get)
            .trackProgressActivity(self.indicator)
            .bind { (result) in
                switch result {
                case .success(let data):
                    guard let data = data.data, let list = data else {
                        return
                    }
                    self.listTrademark.onNext(list)
                case .failure(let err):
                    self.err.onNext(err)
                }
            }.disposed(by: disposeBag)
    }
    func updateProvince(p: [String: Any]) {
        RequestService.shared.APIData(ofType: OptionalMessageDTO<ProvinceOrderModel>.self,
                                      url: APILink.updateProvince.rawValue,
                                      parameters: p,
                                      method: .post)
            .trackProgressActivity(self.indicator)
            .bind { (result) in
                switch result {
                case .success(let data):
                    guard let data = data.data, let list = data else {
                        return
                    }
                    self.updateProvince = list
                case .failure(let err):
                    self.err.onNext(err)
                }
            }.disposed(by: disposeBag)
    }
    func checkLogin() {
        let token = Token()
        if !token.tokenExists {
            self.isLogin = false
        } else {
            self.isLogin = true
        }
    }
    func getListBanner() {
        RequestService.shared.APIData(ofType: OptionalMessageDTO<[Banner]>.self,
                                      url: APILink.banner.rawValue,
                                      parameters: nil,
                                      method: .get)
            .trackProgressActivity(self.indicator)
            .bind { (result) in
                switch result {
                case .success(let data):
                    guard let data = data.data, let list = data else {
                        return
                    }
                    self.listBanner.onNext(list)
                case .failure(let err):
                    self.err.onNext(err)
                }
            }.disposed(by: disposeBag)
    }
    func getListBannerPopup() {
        RequestService.shared.APIData(ofType: OptionalMessageDTO<[Banner]>.self,
                                      url: APILink.bannerPopup.rawValue,
                                      parameters: nil,
                                      method: .get)
            .trackProgressActivity(self.indicator)
            .bind { (result) in
                switch result {
                case .success(let data):
                    guard let data = data.data, let list = data else {
                        return
                    }
                    self.listBannerFooter.onNext(list)
                case .failure(let err):
                    self.err.onNext(err)
                }
            }.disposed(by: disposeBag)
    }
    func getListBannerAdv() {
        RequestService.shared.APIData(ofType: OptionalMessageDTO<BannerAdv>.self,
                                      url: APILink.bannerAdv.rawValue,
                                      parameters: nil,
                                      method: .get)
            .trackProgressActivity(self.indicator)
            .bind { (result) in
                switch result {
                case .success(let data):
                    guard let data = data.data, let list = data else {
                        return
                    }
                    self.listBannerAdv.onNext(list)
                case .failure(let err):
                    self.err.onNext(err)
                }
            }.disposed(by: disposeBag)
    }
    func getListCategory() {
        RequestService.shared.APIData(ofType: OptionalMessageDTO<[CategoryHome]>.self,
                                      url: APILink.category.rawValue,
                                      parameters: nil,
                                      method: .get)
            .trackProgressActivity(self.indicator)
            .bind { (result) in
                switch result {
                case .success(let data):
                    guard let data = data.data, let list = data else {
                        return
                    }
                    self.listCategory.onNext(list)
                case .failure(let err):
                    self.err.onNext(err)
                }
            }.disposed(by: disposeBag)
    }
    func getProductFilter(id: Int, idx: IndexPath, filter: FilterMode) {
        var url = "?per_page=10&page=1&category_id=\(id)?min_price=\(filter.minPrice ?? 0)"
        if let max = filter.maxPrice {
            url += "?max_price=\(max)"
        }
        RequestService.shared.APIData(ofType: OptionalMessageDTO<ProductHome>.self,
                                      url: APILink.product.rawValue + url,
                                      parameters: nil,
                                      method: .get)
            .trackProgressActivity(self.indicator)
            .bind { (result) in
                switch result {
                case .success(let data):
                    guard let data = data.data, let list = data else {
                        return
                    }
//                    self.listProductCategory.onNext((list, idx))
                case .failure(let err):
                    self.err.onNext(err)
                }
            }.disposed(by: disposeBag)
    }
    func getCateloryWithFilter(filter: FilterMode) {
        var url: String = "/product?min_price=\(filter.minPrice ?? 0)"
        if let max = filter.maxPrice {
            url += "?max_price=\(max)"
        }
        RequestService.shared.APIData(ofType: OptionalMessageDTO<ProductHome>.self,
                                      url: url,
                                      parameters: nil,
                                      method: .get)
            .trackProgressActivity(self.indicator)
            .bind { (result) in
                switch result {
                case .success(let data):
                    guard let data = data.data, let list = data else {
                        return
                    }
                    self.listProductFilter.onNext(list)
                case .failure(let err):
                    self.err.onNext(err)
                }
            }.disposed(by: disposeBag)
    }
    func getProduct() {
        RequestService.shared.APIData(ofType: OptionalMessageDTO<[ProductHomeModel]>.self,
                                      url: APILink.home.rawValue,
                                      parameters: nil,
                                      method: .get)
            .trackProgressActivity(self.indicator)
            .bind { (result) in
                switch result {
                case .success(let data):
                    guard let data = data.data, let list = data else {
                        return
                    }
                    self.listProductCategory.onNext(list)
                case .failure(let err):
                    self.err.onNext(err)
                }
            }.disposed(by: disposeBag)
    }
    private func filterMode(list: [Product], filter: FilterMode) -> [Product] {
        return list
            .filter { ($0.maxPrice ?? 0) >= (filter.minPrice ?? 0) }
            .filter { ($0.maxPrice ?? 0) <= (filter.maxPrice ?? 0) }
    }
    func filterListHotProduct(list: [Product], filter: FilterMode) -> [Product] {
        let l = list.filter { $0.isHot == true }
        return self.filterMode(list: l, filter: filter)
    }
    func getListSale(list: [ProductOption]) -> Bool {
        var isSale: Bool = false
        list.forEach { (item) in
            guard let sale = item.isSale, sale == true else {
                isSale = false
                return
            }
            isSale = true
        }
        return isSale
    }
    func listDiscount(list: [Product]) -> [Product] {
        return list
            .filter { (product) -> Bool in
                guard let l = product.productOptions else {
                    return false
                }
                return self.getListSale(list: l)
            }
    }
    func fillterListDiscount(list: [Product], filter: FilterMode) -> [Product] {
        let l = list
            .filter { (product) -> Bool in
                guard let l = product.productOptions else {
                    return false
                }
                return self.getListSale(list: l)
            }
        return self.filterMode(list: l, filter: filter)
    }
    func filterSearchListProduct(list: [Product], textSearch: String) -> [Product] {
        return list
            .filter { $0.isHot == true }
            .filter { ($0.name?.lowercased().contains(textSearch.lowercased()) ?? false) }
    }
    func filterSearchListDiscount(list: [Product], textSearch: String) -> [Product] {
        return list
            .filter { (product) -> Bool in
                guard let l = product.productOptions else {
                    return false
                }
                return self.getListSale(list: l)
            }
            .filter { ($0.name?.lowercased().contains(textSearch.lowercased()) ?? false) }
    }
    func listProductWithFilterAndSearch(list: [Product], filter: FilterMode, textSearch: String) -> [Product] {
        let l = list.filter { $0.isHot == true }
        let lFilter = self.filterMode(list: l, filter: filter)
        return lFilter
            .filter { ($0.name?.lowercased().contains(textSearch.lowercased()) ?? false) }
    }
    func listDiscountWithFilterAndSearch(list: [Product], filter: FilterMode, textSearch: String) -> [Product] {
        let l = list
            .filter { (product) -> Bool in
                guard let l = product.productOptions else {
                    return false
                }
                return self.getListSale(list: l)
            }
        let lFilter = self.filterMode(list: l, filter: filter)
        return lFilter
            .filter { ($0.name?.lowercased().contains(textSearch.lowercased()) ?? false) }
    }
    func listTradeMarkFilter(list: [Product], filter: FilterMode) -> [Product] {
        return self.filterMode(list: list, filter: filter)
    }
    func listTradeMarkSearch(list: [Product], textSearch: String) -> [Product] {
        return list
            .filter { ($0.name?.lowercased().contains(textSearch.lowercased()) ?? false) }
    }
    func listTradeMarkSearchAndFilter(list: [Product], filter: FilterMode, textSearch: String) -> [Product] {
        let l = self.filterMode(list: list, filter: filter)
        return l
            .filter { ($0.name?.lowercased().contains(textSearch.lowercased()) ?? false) }
    }
    
}
