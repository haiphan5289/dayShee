//
//  CartModel.swift
//  Dayshee
//
//  Created by haiphan on 11/7/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import RxSwift
import RxCocoa

class CartModel: ActivityTrackingProgressProtocol  {
    
    var addProduct: PublishSubject<(TypeAddCart, Double)> = PublishSubject.init()
    
    @VariableReplay var totalProduct: Double = 0
    @VariableReplay var dataSource: [HomeDetailModel] = []
    @Replay(queue: MainScheduler.asyncInstance) var indexDelete: Int
    @Replay(queue: MainScheduler.asyncInstance) var promotionCode: PromotionModel?
    @Replay(queue: MainScheduler.asyncInstance) var giftCode: GiftCodeModel?
    @VariableReplay var listPromotion: [PromotionModel] = []
    @Replay(queue: MainScheduler.asyncInstance) var isLogin: Bool
    @Replay(queue: MainScheduler.asyncInstance) var cartDetail: CartModelDetail
    @Replay(queue: MainScheduler.asyncInstance) var err: String?
    private let disposeBag = DisposeBag()
    func setupRX() {
        dataSource = RealmManager.shared.getCartProduct()
        
        self.getListPromotion()
        
        addProduct.asObservable().bind { [weak self] (type, priceProdoct) in
            guard let wSelf = self else {
                return
            }
            guard type == .add else {
                wSelf.totalProduct -= priceProdoct
                return
            }
            wSelf.totalProduct += priceProdoct
        }.disposed(by: disposeBag)
        
        self.$indexDelete.asObservable().bind { [weak self] (row) in
            guard let wSelf = self else {
                return
            }
            let item = wSelf.dataSource[row]
            RealmManager.shared.deleteCart(item: item)
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
    
    func removeAll() {
        RealmManager.shared.deleteCarAll()
    }
    func promotionValid(text: String)  {
        for i in self.listPromotion {
            if i.promotionCode == text {
                promotionCode = i
                self.err = nil
                return
            }
        }
        self.err = "Mã code không hợp lệ"
        promotionCode = nil
        
    }
    func getListPromotion() {
        RequestService.shared.APIData(ofType: OptionalMessageDTO<[PromotionModel]>.self,
                                      url: APILink.promotion.rawValue,
                                      parameters: nil,
                                      method: .get)
            .trackProgressActivity(self.indicator)
            .bind { (result) in
                switch result {
                case .success(let data):
                    guard let data = data.data, let list = data else {
                        return
                    }
                    self.listPromotion = list
                case .failure(let err):
                    self.err = err.message
                }
            }.disposed(by: disposeBag)
    }
    func getCartInfo(p: [String: Any]) {
        RequestService.shared.APIData(ofType: OptionalMessageDTO<CartModelDetail>.self,
                                      url: APILink.cart.rawValue,
                                      parameters: p,
                                      method: .post)
            .trackProgressActivity(self.indicator)
            .bind { (result) in
                switch result {
                case .success(let data):
                    guard let data = data.data, let list = data else {
                        return
                    }
                    self.cartDetail = list
                case .failure(let err):
                    self.err = err.message
                }
            }.disposed(by: disposeBag)
    }
}
