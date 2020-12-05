//
//  FormOfDeliveryVM.swift
//  Dayshee
//
//  Created by paxcreation on 11/13/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import RxCocoa
import RxSwift

class FormOfDeliveryVM: ActivityTrackingProgressProtocol {
    
    @Replay(queue: MainScheduler.asyncInstance) var listDelivery: [DeliveryMode]
    @Replay(queue: MainScheduler.asyncInstance) var err: ErrorService
    @Replay(queue: MainScheduler.asyncInstance) var isLogin: Bool
    @Replay(queue: MainScheduler.asyncInstance) var shipMode: DeliveryMode
    @Replay(queue: MainScheduler.asyncInstance) var moveToDeliveryAddress: Void
    @Replay(queue: MainScheduler.asyncInstance) var moveToListAddress: Bool
    @Replay(queue: MainScheduler.asyncInstance) var orderSuccess: OrderCart
    @Replay(queue: MainScheduler.asyncInstance) var listAddress: ListAddress
    private let disposeBag = DisposeBag()
    func setupRX() {
        let token = Token()
        isLogin = token.tokenExists
//        self.getListDelivery()
        self.getListAddress()
    }
    func getListDelivery() {
        RequestService.shared.APIData(ofType: OptionalMessageDTO<[DeliveryMode]>.self,
                                      url: APILink.delivery.rawValue,
                                      parameters: nil,
                                      method: .get)
            .trackProgressActivity(self.indicator)
            .subscribe(onNext: { [weak self] (result) in
                switch result {
                case .success(let data):
                    guard  let wSelf = self else {
                        return
                    }
                    guard let data = data.data, let list = data else {
                        return
                    }
                    wSelf.listDelivery = list
                case .failure(let err):
                    self?.err = err
                }
            }, onError: { (err) in
                print("\(err.localizedDescription)")
            }).disposed(by: disposeBag)
    }
    func postOrder(p: [String: Any]) {
        RequestService.shared.APIData(ofType: OptionalMessageDTO<OrderCart>.self,
                                      url: APILink.order.rawValue,
                                      parameters: p,
                                      method: .post)
            .trackProgressActivity(self.indicator)
            .bind { [weak self] (result) in
                                        switch result {
                                        case .success(let data):
                                            guard let data = data.data, let order = data else {
                                                return
                                            }
                                            self?.orderSuccess = order
                                        case .failure(let err):
                                            self?.err = err
                                        }
                                      }.disposed(by: disposeBag)
    }
    func getListAddress() {
        let url = "/address?page=1&per_page=10"
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
    func getUserInfo() -> RegisterTemp {
        let token = Token()
        var user = RegisterTemp()
        user.name = token.user?.name
        user.address = token.user?.address
        user.district = token.user?.districtID
        user.phone = token.user?.phone
        user.zone = token.user?.provinceID
        user.ward = token.user?.wardID
        user.id = token.user?.id
        return user
    }
}
