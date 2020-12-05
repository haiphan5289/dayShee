//
//  ProductDetailVM.swift
//  Dayshee
//
//  Created by paxcreation on 11/9/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import RxSwift
import RxCocoa

class ProductDetailVM: ActivityTrackingProgressProtocol {
    @Replay(queue: MainScheduler.asyncInstance) var dataSource: HomeDetailModel
    @Replay(queue: MainScheduler.asyncInstance) var err: ErrorService
    private let disposeBag = DisposeBag()
    func getDetailProduct(id: Int) {
        let url = "/product/\(id)"
        RequestService.shared.APIData(ofType: OptionalMessageDTO<HomeDetailModel>.self,
                                      url: url,
                                      parameters: nil,
                                      method: .get)
            .trackProgressActivity(self.indicator)
            .bind { [weak self] (result) in
                                        switch result {
                                        case .success(let data):
                                            guard  let wSelf = self else {
                                                return
                                            }
                                            guard let data = data.data, let list = data else {
                                                return
                                            }
                                            wSelf.dataSource = list
                                        case .failure(let err):
                                            self?.err = err
                                        }
                                      }.disposed(by: disposeBag)
    }
}
