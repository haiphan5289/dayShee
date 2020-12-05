//
//  APIOrder.swift
//  WoodPeckers
//
//  Created by Macbook on 6/4/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import Foundation
import Alamofire
class APIOrder: NSObject {
    
    static let shared = APIOrder()
    
    func listOrder(parameters : [String : Any]?, completion: @escaping ((_ model: BasePagingModel<ProductModel>?)->Void)) {
        let url = SERVER + "orders?status="
        RequestService.shared.requestWith(url, .get, parameters, nil, objectType: BasePagingModel<ProductModel>.self, encoding: URLEncoding.default) { ( data) in
            guard let model = data as? BasePagingModel<ProductModel> else {
                completion(nil)
                return
            }
            completion(model)
        }
    }
  
    func createOrder(parameters : [String : Any]?, completion: @escaping ((_ model: BaseModel<ProductModel>?)->Void)) {
        let url = SERVER + "orders/create"
        RequestService.shared.requestWith(url, .post, parameters, nil, objectType: BaseModel<ProductModel>.self, encoding: JSONEncoding.default) { (data) in
            guard let model = data as? BaseModel<ProductModel> else {
                completion(nil)
                return
            }
            completion(model)
        }
    }
    
    
    
    
}
