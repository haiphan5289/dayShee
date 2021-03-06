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
    @Replay(queue: MainScheduler.asyncInstance) var favorite: String
    @Replay(queue: MainScheduler.asyncInstance) var dislike: FavouriteModel
    @Replay(queue: MainScheduler.asyncInstance) var err: ErrorService
    @Replay(queue: MainScheduler.asyncInstance) var isLogin: Bool
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
    func checkLogin() {
        let token = Token()
        if !token.tokenExists {
            self.isLogin = false
        } else {
            self.isLogin = true
        }
    }
    func sendLove(p: [String: Any]) {
        RequestService.shared.APIData(ofType: OptionalMessageDTO<FavouriteModel>.self,
                                      url: APILink.favorite.rawValue,
                                      parameters: p,
                                      method: .post)
            .trackProgressActivity(self.indicator)
            .bind { [weak self] (result) in
                switch result {
                case .success(let data):
                    guard  let wSelf = self else {
                        return
                    }
                    wSelf.favorite = data.message ?? ""
                case .failure(let _):
                    //                    self?.err = err
                    break
                }
            }.disposed(by: disposeBag)
    }
    func dislike(p: [String: Any]) {
        RequestService.shared.APIData(ofType: OptionalMessageDTO<FavouriteModel>.self,
                                      url: APILink.favorite.rawValue,
                                      parameters: p,
                                      method: .post)
            .trackProgressActivity(self.indicator)
            .bind { [weak self] (result) in
                switch result {
                case .success(let data):
                    guard  let wSelf = self else {
                        return
                    }
                    wSelf.favorite = data.message ?? ""
                case .failure(let _):
                    //                    self?.err = err
                    break
                }
            }.disposed(by: disposeBag)
    }
}
