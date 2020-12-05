//
//  ListAddressDeliveryVM.swift
//  Dayshee
//
//  Created by paxcreation on 11/18/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import RxCocoa
import RxSwift

class ListAddressDeliveryVM: ActivityTrackingProgressProtocol {
    @Replay(queue: MainScheduler.asyncInstance) var err: ErrorService
    @Replay(queue: MainScheduler.asyncInstance) var listAddress: ListAddress
    @Replay(queue: MainScheduler.asyncInstance) var listAddressCallBack: ListAddress
    @Replay(queue: MainScheduler.asyncInstance) var updateAddressDefault: AddressModel
    private let disposeBag = DisposeBag()
    func getListAddress(page: Int) {
        let url = "/address?page=\(page)&per_page=10"
        RequestService.shared.APIData(ofType: OptionalMessageDTO<ListAddress>.self,
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
                    self.listAddress = model
                case .failure(let err):
                    self.err = err
                }}.disposed(by: disposeBag)
    }
    func getListAddressCheck(page: Int) ->  Observable<ApiResult<OptionalMessageDTO<ListAddress>, ErrorService>>  {
        let url = "/address?page=\(page)&per_page=10"
       return RequestService.shared.APIData(ofType: OptionalMessageDTO<ListAddress>.self,
                                      url: url,
                                      parameters: nil,
                                      method: .get)
            .trackProgressActivity(self.indicator)
            .map { (result) in
                return result
            }
    }
    func getListAddressCallBack() {
        let url = "/address?page=\(1)&per_page=10"
        RequestService.shared.APIData(ofType: OptionalMessageDTO<ListAddress>.self,
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
                    self.listAddressCallBack = model
                case .failure(let err):
                    self.err = err
                }}.disposed(by: disposeBag)
    }
    func deleteAddress(id: Int) {
        let url = "/address/\(id)"
        RequestService.shared.APIData(ofType: OptionalMessageDTO<ListAddress>.self,
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
                    self.listAddressCallBack = model
                case .failure(let err):
                    self.err = err
                }}.disposed(by: disposeBag)
    }
    func updateDefaultAddress(p: [String: Any]) {
        RequestService.shared.APIData(ofType: OptionalMessageDTO<AddressModel>.self,
                                      url: APILink.updateDefaultAddress.rawValue,
                                      parameters: p,
                                      method: .post)
            .trackProgressActivity(self.indicator)
            .bind { (result) in
                switch result {
                case .success(let value):
                    guard let data = value.data, let model = data else {
                        return
                    }
                    self.updateAddressDefault = model
                case .failure(let err):
                    self.err = err
                }}.disposed(by: disposeBag)
    }
}
