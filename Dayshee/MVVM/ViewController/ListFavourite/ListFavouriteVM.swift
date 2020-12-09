//
//  ListFavouriteVM.swift
//  Dayshee
//
//  Created by paxcreation on 12/9/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import RxCocoa
import RxSwift

class ListFavouriteVM: ActivityTrackingProgressProtocol {
    @Replay(queue: MainScheduler.asyncInstance) var err: ErrorService
    @Replay(queue: MainScheduler.asyncInstance) var listFavourite: ListFavouriteModel
    @Replay(queue: MainScheduler.asyncInstance) var listFavouriteCallBack: ListFavouriteModel
    private let disposeBag = DisposeBag()
    func getListFavourite(page: Int) ->  Observable<ApiResult<OptionalMessageDTO<ListFavouriteModel>, ErrorService>>  {
        let url = "/product/favourite?product_id=1&page=\(page)&per_page=10"
       return RequestService.shared.APIData(ofType: OptionalMessageDTO<ListFavouriteModel>.self,
                                      url: url,
                                      parameters: nil,
                                      method: .get)
            .trackProgressActivity(self.indicator)
            .map { (result) in
                return result
            }
    }
    func getListFavouriteCallBack() {
        let url = "/product/favourite?product_id=1&page=1&per_page=10"
        RequestService.shared.APIData(ofType: OptionalMessageDTO<ListFavouriteModel>.self,
                                      url: url,
                                      parameters: nil,
                                      method: .get)
            .trackProgressActivity(self.indicator)
            .bind { (result) in
                switch result {
                case .success(let value):
                    guard let data = value.data, let model = data else {
                        return
                    }
                    self.listFavouriteCallBack = model
                case .failure(let err):
                    self.err = err
                }}.disposed(by: disposeBag)
    }
    func deleteAddress(id: Int) {
        let url = "/address/\(id)"
        RequestService.shared.APIData(ofType: OptionalMessageDTO<ListFavouriteModel>.self,
                                      url: url,
                                      parameters: nil,
                                      method: .delete)
            .trackProgressActivity(self.indicator)
            .bind { (result) in
                switch result {
                case .success(let value):
                    guard let data = value.data, let model = data else {
                        return
                    }
                    self.listFavouriteCallBack = model
                case .failure(let err):
                    self.err = err
                }}.disposed(by: disposeBag)
    }
}

