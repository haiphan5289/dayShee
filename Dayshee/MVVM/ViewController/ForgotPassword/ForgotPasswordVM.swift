//
//  ForgotPasswordVM.swift
//  Dayshee
//
//  Created by haiphan on 11/17/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import RxCocoa
import RxSwift

class ForgotPasswordVM: ActivityTrackingProgressProtocol {
    @Replay(queue: MainScheduler.asyncInstance) var err: ErrorService
    @Replay(queue: MainScheduler.asyncInstance) var item: ForgotPasswordModel
    private let disposeBag = DisposeBag()
    func checkPhone(phone: String) {
        let p: [String : Any] = ["phone": phone]
        RequestService.shared.APIData(ofType: OptionalMessageDTO<ForgotPasswordModel>.self,
                                      url: APILink.forgotPassword.rawValue,
                                      parameters: p,
                                      method: .post)
            .trackProgressActivity(self.indicator)
            .bind { [weak self] (result) in
                switch result {
                case .success(let data):
                    guard let data = data.data, let item = data else {
                        return
                    }
                    self?.item = item
                case .failure(let err):
                    self?.err = err
                }
            }.disposed(by: disposeBag)
    }
}
