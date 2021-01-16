//
//  ListPromotionVM.swift
//  Dayshee
//
//  Created by haiphan on 1/9/21.
//  Copyright © 2021 ThanhPham. All rights reserved.
//

import RxCocoa
import RxSwift

class ListPromotionVM: ActivityTrackingProgressProtocol {
    @Replay(queue: MainScheduler.asyncInstance) var err: ErrorService
    @VariableReplay var listPromotion: GiftCodePaging?
    @VariableReplay var listPromotionCallBack: GiftCodePaging?
    
    private let disposeBag = DisposeBag()
    func getListDiscount(page: Int, text: String) ->  Observable<ApiResult<OptionalMessageDTO<GiftCodePaging>, ErrorService>>  {
//        let url = "/post?page=\(page)&per_page=10"
        let url = "?gift_code=\(text)&page=\(page)&per_page=10"
       return RequestService.shared.APIData(ofType: OptionalMessageDTO<GiftCodePaging>.self,
                                      url: APILink.giftCode.rawValue + url,
                                      parameters: nil,
                                      method: .get)
            .trackProgressActivity(self.indicator)
            .map { (result) in
                return result
            }
    }
    func getListAddressCallBack(text: String, page: Int) {
        let url = "?gift_code=\(text)&page=\(page)&per_page=10"
        RequestService.shared.APIData(ofType: OptionalMessageDTO<GiftCodePaging>.self,
                                      url: APILink.giftCode.rawValue + url,
                                      parameters: nil,
                                      method: .get)
            .trackProgressActivity(self.indicator)
            .subscribe(onNext: { (result) in
                switch result {
                case .success(let value):
                    guard let data = value.data, let model = data else {
                        return
                    }
                    self.listPromotionCallBack = model
                case .failure(let err):
                    self.err = err
                }
            }, onError: { (err) in
                print("\(err.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
}
