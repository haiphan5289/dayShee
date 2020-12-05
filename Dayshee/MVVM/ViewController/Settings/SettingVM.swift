//
//  SettingVM.swift
//  Dayshee
//
//  Created by haiphan on 11/2/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import RxCocoa
import RxSwift

class SettingVM: ActivityTrackingProgressProtocol {
    var user: PublishSubject<UserInfo> = PublishSubject.init()
    var err: PublishSubject<ErrorService> = PublishSubject.init()
    @Replay(queue: MainScheduler.asyncInstance) var logOut: ForgotPasswordModel
    @Replay(queue: MainScheduler.asyncInstance) var isLogin: Bool
    private let disposeBag = DisposeBag()
    
    func getDetail() {
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
                                            self.user.onNext(item)
                                        case .failure(let err):
                                            self.err.onNext(err)
                                        }}.disposed(by: disposeBag)
    }
    func checkLogin() {
        let token = Token()
        if !token.tokenExists {
            self.isLogin = false
        } else {
            self.isLogin = true
        }
    }
    func deleteAllData() {
        let token = Token()
        token.clear()
        self.checkLogin()
        RealmManager.shared.deleteCarAll()
    }
    
    func getLogOut() {
        RequestService.shared.APIData(ofType: OptionalMessageDTO<ForgotPasswordModel>.self,
                                      url: APILink.logOut.rawValue,
                                      parameters: nil,
                                      method: .post)
            .trackProgressActivity(self.indicator)
            .bind { (result) in
                                        switch result {
                                        case .success(let value):
                                            guard let data = value.data, let item = data else {
                                                return
                                            }
                                            self.logOut = item
                                        case .failure(let err):
                                            self.err.onNext(err)
                                        }}.disposed(by: disposeBag)
    }
}
