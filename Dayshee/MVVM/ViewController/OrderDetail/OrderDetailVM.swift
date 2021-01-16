//
//  OrderDetailMode.swift
//  Dayshee
//
//  Created by haiphan on 11/21/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import RxCocoa
import RxSwift

class OrderDetailVM: ActivityTrackingProgressProtocol {
    @Replay(queue: MainScheduler.asyncInstance) var err: ErrorService
    @Replay(queue: MainScheduler.asyncInstance) var orderModel: OrderInfo
    @Replay(queue: MainScheduler.asyncInstance) var location: [Location]
    @Replay(queue: MainScheduler.asyncInstance) var cancelSuccess: Bool
    private let disposeBag = DisposeBag()

    func updateStatusOrder(p: [String: Any]) {
        RequestService.shared.APIData(ofType: OptionalMessageDTO<OrderInfo>.self,
                                      url: APILink.updateStatus.rawValue,
                                      parameters: p,
                                      method: .post)
            .trackProgressActivity(self.indicator)
            .bind { (result) in
                switch result {
                case .success(let value):
                    guard let data = value.data, let model = data else {
                        return
                    }
                    self.orderModel = model
                case .failure(let err):
                    self.err = err
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
                    self.location = model
                    self.insertRealm(items: model)
                case .failure(let err):
                    self.err = err
                }}.disposed(by: disposeBag)
    }
    
    func getOrder(id: Int) {
        let url = "/order/\(id)"
        RequestService.shared.APIData(ofType: OptionalMessageDTO<OrderInfo>.self,
                                      url: url,
                                      parameters: nil,
                                      method: .get)
            .trackProgressActivity(self.indicator)
            .subscribe { (result) in
                switch result {
                case .success(let value):
                    guard let data = value.data, let model = data else {
                        return
                    }
                    self.orderModel = model
                case .failure(let err):
                self.err = err
                }
            } onError: { (err) in
                print(err)
            }.disposed(by: disposeBag)

    }
    func cancelOrder(p: [String: Any]) {
        RequestService.shared.APIData(ofType: OptionalMessageDTO<OrderInfo>.self,
                                      url: APILink.cancelOrder.rawValue,
                                      parameters: p,
                                      method: .post)
            .trackProgressActivity(self.indicator)
            .bind { [weak self] (result) in
                switch result {
                case .success(let value):
                    guard let wSelf = self ,let data = value.data, let _ = data else {
                        return
                    }
                    wSelf.cancelSuccess = true
                case .failure(let err):
                    self?.err = err
                }}.disposed(by: disposeBag)
    }
    private func insertRealm(items: [Location]) {
        items.forEach { (value) in
            let v = LocationRealm(model: value)
            RealmManager.shared.insertLocation(item: v)
        }
    }
}
