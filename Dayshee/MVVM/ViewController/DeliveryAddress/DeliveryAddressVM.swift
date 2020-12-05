//
//  DeliveryAddressVM.swift
//  Dayshee
//
//  Created by haiphan on 11/14/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import RxSwift
import RxCocoa

class DeliveryAddressVM: ActivityTrackingProgressProtocol {
    
    var data: BehaviorRelay<UserInfo?> = BehaviorRelay.init(value: nil)
//    @Replay(queue: MainScheduler.asyncInstance) var data: UserInfo
    @Replay(queue: MainScheduler.asyncInstance) var address: AddressModel
    
    var location: PublishSubject<[Location]> = PublishSubject.init()
    var err: PublishSubject<ErrorService> = PublishSubject.init()
    private let disposeBag = DisposeBag()
    
    private func getDetail() {
        RequestService.shared.APIData(ofType: OptionalMessageDTO<UserInfo>.self,
                                      url: APILink.profile.rawValue,
                                      parameters: nil,
                                      method: .get)
            .trackProgressActivity(self.indicator)
            .bind { (result) in
                                        switch result {
                                        case .success(let value):
                                            guard let data = value.data, let item = data else {
                                                return
                                            }
                                            var tokenSave = Token()
                                            tokenSave.email = item.email
                                            tokenSave.user = item
                                            self.data.accept(item)
                                        case .failure(let err):
                                            self.err.onNext(err)
                                        }}.disposed(by: disposeBag)
    }
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
    func addAddress(p: [String : Any]) {
        RequestService.shared.APIData(ofType: OptionalMessageDTO<AddressModel>.self,
                                      url: APILink.addAddress.rawValue,
                                      parameters: p,
                                      method: .post)
            .trackProgressActivity(self.indicator)
            .bind { (result) in
                                        switch result {
                                        case .success(let value):
                                            guard let data = value.data, let model = data else {
                                                return
                                            }
                                            self.address = model
                                        case .failure(let err):
                                            self.err.onNext(err)
                                        }}.disposed(by: disposeBag)
    }
    func updateAddress(p: [String : Any]) {
        RequestService.shared.APIData(ofType: OptionalMessageDTO<AddressModel>.self,
                                      url: APILink.updateAddress.rawValue,
                                      parameters: p,
                                      method: .post)
            .trackProgressActivity(self.indicator)
            .bind { (result) in
                                        switch result {
                                        case .success(let value):
                                            guard let data = value.data, let model = data else {
                                                return
                                            }
                                            self.address = model
                                        case .failure(let err):
                                            self.err.onNext(err)
                                        }}.disposed(by: disposeBag)
    }

}
