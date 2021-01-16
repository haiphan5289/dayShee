//
//  AuthenViewModel.swift
//  SnapChat
//
//  Created by admin on 5/5/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AuthenViewModel: ActivityTrackingProgressProtocol {
    var userInfo: PublishSubject<UserInfo> = PublishSubject.init()
    var err: PublishSubject<ErrorService> = PublishSubject.init()
    var checkPhone: PublishSubject<Bool> = PublishSubject.init()
    @Replay(queue: MainScheduler.asyncInstance) var updateProvince: ProvinceOrderModel
    private let disposeBag = DisposeBag()
    func login(parameters : [String : Any]?, _ completeHandler:@escaping (_ success: Bool,_ data: UserModel?, _ message : String) ->()) {
        APIServices.shared.login(parameters: parameters) { (data) in
            guard let user = data?.data, let token = user.token else{
                completeHandler(false, nil, data?.message ?? "Error")
                return
            }
            var tokenSave = Token()
            //            tokenSave.user = user
            if let pass = parameters!["password"] as? String {
                tokenSave.password = pass
            }
            tokenSave.email = user.user?.email ?? ""
            tokenSave.token = token
            if data?.result == true {
                completeHandler(true, user, data?.message ?? "")
            }else {
                completeHandler(false,nil, data?.message ?? "")
            }
        }
    }
    func updateProvince(p: [String: Any]) {
        RequestService.shared.APIData(ofType: OptionalMessageDTO<ProvinceOrderModel>.self,
                                      url: APILink.updateProvince.rawValue,
                                      parameters: p,
                                      method: .post)
            .trackProgressActivity(self.indicator)
            .bind { (result) in
                switch result {
                case .success(let data):
                    guard let data = data.data, let list = data else {
                        return
                    }
                    self.updateProvince = list
                case .failure(let err):
                    self.err.onNext(err)
                }
            }.disposed(by: disposeBag)
    }
    
    func getLogin(p: [String: Any]) {
        RequestService
            .shared
            .APIData(ofType: OptionalMessageDTO<UserInfo>.self,
                     url: APILink.login.rawValue,
                     parameters: p,
                     method: .post)
            .trackProgressActivity(self.indicator)
            .bind { [weak self] (result) in
                guard let wSelf = self else {
                    return
                }
                switch result {
                case .success(let data):
                    guard let user = data.data, let item = user, let token = item.token else {
                        return
                    }
                    var tokenSave = Token()
                    if let pass = p["password"] as? String {
                        tokenSave.password = pass
                    }
                    tokenSave.email = item.email
                    tokenSave.token = token
                    tokenSave.user = item
                    wSelf.userInfo.onNext(item)
                case .failure(let err):
                    wSelf.err.onNext(err)
                }
            }.disposed(by: disposeBag)
    }
    func checkPhone(p: [String: Any]) {
        RequestService.shared.APIData(ofType: OptionalMessageDTO<ForgotPasswordModel>.self,
                                      url: APILink.checkPhone.rawValue,
                                      parameters: p,
                                      method: .post)
            .trackProgressActivity(self.indicator)
            .bind { [weak self] (result) in
                guard let wSelf = self else {
                    return
                }
                switch result {
                case .success(let _):
                    wSelf.checkPhone.onNext(true)
                case .failure(let err):
                    wSelf.err.onNext(err)
                }
            }.disposed(by: disposeBag)
    }
    
    
    
}
