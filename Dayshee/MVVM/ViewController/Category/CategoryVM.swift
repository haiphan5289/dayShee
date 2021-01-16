//
//  CategoryVM.swift
//  Dayshee
//
//  Created by haiphan on 11/22/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import RxCocoa
import RxSwift

class CategoryVM: ActivityTrackingProgressProtocol {
    @Replay(queue: MainScheduler.asyncInstance) var listProduct: ProductHome
    @Replay(queue: MainScheduler.asyncInstance) private var err: ErrorService
    private let disposeBag = DisposeBag()
    func filterMode(list: [Product], filter: FilterMode) -> [Product] {
        guard filter.minPrice != nil else {
            return list
        }
        return list
            .filter { ($0.maxPrice ?? 0) >= (filter.minPrice ?? 0) }
            .filter { ($0.maxPrice ?? 0) <= (filter.maxPrice ?? 0) }
    }
    func searchAndFilterMode(list: [Product], filter: FilterMode, textSearch: String) -> [Product] {
        guard filter.minPrice != nil else {
            return list.filter { ($0.name?.lowercased().contains(textSearch.lowercased()) ?? false) }
        }
        return list
            .filter { ($0.maxPrice ?? 0) >= (filter.minPrice ?? 0) }
            .filter { ($0.maxPrice ?? 0) <= (filter.maxPrice ?? 0) }
            .filter { ($0.name?.lowercased().contains(textSearch.lowercased()) ?? false) }
    }
    func getCateloryWithFilterCallBack(page: Int, p: [String: Any]) ->  Observable<ApiResult<OptionalMessageDTO<ProductHome>, ErrorService>>  {
        var url: String = "?"
        p.enumerated().forEach { (b) in
            if b.offset == 0 {
                url += "\(b.element.key)=\(b.element.value)"
            } else {
                url += "&\(b.element.key)=\(b.element.value)"
            }
        }
        url += "&page=\(page)&per_page=10"
       return RequestService.shared.APIData(ofType: OptionalMessageDTO<ProductHome>.self,
                                      url: APILink.giftCode.rawValue + url,
                                      parameters: nil,
                                      method: .get)
            .trackProgressActivity(self.indicator)
            .map { (result) in
                return result
            }
    }
    func getCateloryWithFilter(p: [String: Any], page: Int) {
        var url: String = "?"
        p.enumerated().forEach { (b) in
            if b.offset == 0 {
                url += "\(b.element.key)=\(b.element.value)"
            } else {
                url += "&\(b.element.key)=\(b.element.value)"
            }
        }
        url += "&page=\(page)&per_page=10"
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
                    self.listProduct = list
                case .failure(let err):
                    self.err = err
                break
                }
            }.disposed(by: disposeBag)
    }

    
}
