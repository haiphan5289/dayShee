//
//  ProfileDetailVM.swift
//  Dayshee
//
//  Created by haiphan on 11/2/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//
import RxCocoa
import RxSwift

class ProfileDetailVM: ActivityTrackingProgressProtocol {
    
    var location: PublishSubject<[Location]> = PublishSubject.init()
    var err: PublishSubject<ErrorService> = PublishSubject.init()
    @Replay(queue: MainScheduler.asyncInstance) var user: UserInfo
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
                case .failure(let err):
                    self.err.onNext(err)
                }}.disposed(by: disposeBag)
    }
    func updateProfile(p: [String: Any], img: [UIImage]?, urlIMG: String) {
        RequestService.shared.APIUpload(ofType: OptionalMessageDTO<UserInfo>.self,
                                        url: SERVER + APILink.updateProfile.rawValue,
                                        parameters: p,
                                        method: .post,
                                        header: nil,
                                        urlIMG: urlIMG,
                                        img: img)
            .trackProgressActivity(self.indicator)
            .bind { (result) in
                switch result {
                case .success(let data):
                    guard let user = data.data, let item = user else {
                        return
                    }
                    self.user = item
                case .failure(let err):
                    self.err.onNext(err)
                }}.disposed(by: disposeBag)
    }
}
