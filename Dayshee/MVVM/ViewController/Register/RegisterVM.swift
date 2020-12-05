//
//  RegisterVM.swift
//  Dayshee
//
//  Created by haiphan on 10/31/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

class RegisterVM: ActivityTrackingProgressProtocol {
    var data: PublishSubject<UserInfo> = PublishSubject.init()
    var location: PublishSubject<[Location]> = PublishSubject.init()
    var err: PublishSubject<ErrorService> = PublishSubject.init()
    private let disposeBag = DisposeBag()
    
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
                    self.location.onNext(model)
                    self.insertRealm(items: model)
                case .failure(let err):
                    self.err.onNext(err)
                }}.disposed(by: disposeBag)
    }
    func uploadImage(p: [String: Any], img: UIImage, urlIMG: String) {
        RequestService.shared.APIUpload(ofType: OptionalMessageDTO<UserInfo>.self,
                                        url: SERVER + APILink.register.rawValue,
                                        parameters: p,
                                        method: .post,
                                        header: nil,
                                        urlIMG: urlIMG,
                                        img: img)
            .bind { (result) in
                switch result {
                case .success(let data):
                    guard let user = data.data,
                          let item = user,
                          let token = item.token else {
                        return
                    }
                    var tokenSave = Token()
                    if let pass = p["password"] as? String {
                        tokenSave.password = pass
                    }
                    tokenSave.email = item.email
                    tokenSave.token = token
                    tokenSave.user = item
                    self.data.onNext(item)
                case .failure(let err):
                    self.err.onNext(err)
                }}.disposed(by: disposeBag)
    }
    private func insertRealm(items: [Location]) {
        items.forEach { (value) in
            let v = LocationRealm(model: value)
            RealmManager.shared.insertLocation(item: v)
        }
    }
}
