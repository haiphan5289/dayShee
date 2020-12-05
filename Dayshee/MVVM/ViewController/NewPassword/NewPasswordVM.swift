//
//  NewPasswordVM.swift
//  Dayshee
//
//  Created by haiphan on 11/17/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import RxSwift
import RxCocoa

class NewPasswordVM: ActivityTrackingProgressProtocol {
    @Replay(queue: MainScheduler.asyncInstance) var err: ErrorService
    @Replay(queue: MainScheduler.asyncInstance) var user: UserInfo
    
    private let disposeBag = DisposeBag()
    func newPass(p: [String : Any]) {
        RequestService.shared.APIData(ofType: OptionalMessageDTO<UserInfo>.self,
                                      url: APILink.newPass.rawValue,
                                      parameters: p,
                                      method: .post)
            .trackProgressActivity(self.indicator)
            .bind { [weak self] (result) in
                switch result {
                case .success(let data):
                    guard let data = data.data, let item = data else {
                        return
                    }
                    self?.user = item
                case .failure(let err):
                    self?.err = err
                }
            }.disposed(by: disposeBag)
    }
}
