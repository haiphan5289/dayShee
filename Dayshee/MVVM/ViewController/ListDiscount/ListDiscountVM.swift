//
//  ListDiscountVM.swift
//  Dayshee
//
//  Created by haiphan on 11/19/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import RxCocoa
import RxSwift

class ListDiscountVM: ActivityTrackingProgressProtocol {
    @Replay(queue: MainScheduler.asyncInstance) var err: ErrorService
    @Replay(queue: MainScheduler.asyncInstance) var listDiscount: ListDiscountModel
    @Replay(queue: MainScheduler.asyncInstance) var listDiscountCallBack: ListDiscountModel
    
    private let disposeBag = DisposeBag()
    func getListDiscount(page: Int) ->  Observable<ApiResult<OptionalMessageDTO<ListDiscountModel>, ErrorService>>  {
        let url = "/post?page=\(page)&per_page=10"
       return RequestService.shared.APIData(ofType: OptionalMessageDTO<ListDiscountModel>.self,
                                      url: url,
                                      parameters: nil,
                                      method: .get)
            .trackProgressActivity(self.indicator)
            .map { (result) in
                return result
            }
    }
    func getListAddressCallBack() {
        let url = "/post?page=\(1)&per_page=10"
        RequestService.shared.APIData(ofType: OptionalMessageDTO<ListDiscountModel>.self,
                                      url: url,
                                      parameters: nil,
                                      method: .get)
            .trackProgressActivity(self.indicator)
            .subscribe(onNext: { (result) in
                switch result {
                case .success(let value):
                    guard let data = value.data, let model = data else {
                        return
                    }
                    self.listDiscountCallBack = model
                case .failure(let err):
                    self.err = err
                }
            }, onError: { (err) in
                print("\(err.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
}
