//
//  OrdersVM.swift
//  Dayshee
//
//  Created by haiphan on 11/21/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import RxCocoa
import RxSwift

class OrdersVM: ActivityTrackingProgressProtocol {
    @Replay(queue: MainScheduler.asyncInstance) var err: ErrorService
    @Replay(queue: MainScheduler.asyncInstance) var orderModel: OrderPaging
    @Replay(queue: MainScheduler.asyncInstance) var listOrderCallBack: OrderPaging
    private let disposeBag = DisposeBag()
    func getListAddressCheck(page: Int) ->  Observable<ApiResult<OptionalMessageDTO<OrderPaging>, ErrorService>>  {
        let url = "/order?page=\(page)&per_page=10"
       return RequestService.shared.APIData(ofType: OptionalMessageDTO<OrderPaging>.self,
                                      url: url,
                                      parameters: nil,
                                      method: .get)
            .trackProgressActivity(self.indicator)
            .map { (result) in
                return result
            }
    }
    func getListAddressCallBack() {
        let url = "/order?page=1&per_page=10"
        RequestService.shared.APIData(ofType: OptionalMessageDTO<OrderPaging>.self,
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
                    self.listOrderCallBack = model
                case .failure(let err):
                    self.err = err
                }}.disposed(by: disposeBag)
    }
}
