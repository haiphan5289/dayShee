//
//  OrderViewModel.swift
//  WoodPeckers
//
//  Created by Macbook on 6/4/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import Foundation
class OrderViewModel:NSObject {
    
    func listOrder(parameters : [String : Any]?, _ completeHandler:@escaping ((_ data: BasePagingModel<ProductModel>?) ->())) {
        APIOrder.shared.listOrder(parameters: parameters) { (data) in
            guard let data = data else{
                completeHandler(nil)
                return
            }
            completeHandler(data)
        }
    }
    
    func createOrder(parameters : [String : Any]?, _ completeHandler:@escaping ((_ data: BaseModel<ProductModel>?) ->())) {
        APIOrder.shared.createOrder(parameters: parameters) { (data) in
            guard let data = data else{
                completeHandler(nil)
                return
            }
            completeHandler(data)
        }
    }
    
}
