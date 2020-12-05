//
//  AdminViewModel.swift
//  Knowitall
//
//  Created by thanhnguyen on 4/13/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import Foundation

class AdminViewModel {
    
    func decideBet(paramters : [String : Any]?, _ completeHander: @escaping ((_ success : Bool , _ data : BaseModel<DataListModel>?,  _ message : String)->())){
        ApiAdmin.shared.decideBet(paramters: paramters) { (data) in
            if let data = data , data.status == true {
                completeHander(true , data , data.message ?? kMsgSuccessCommon)
            }else {
                completeHander(false , nil , data?.message ?? kMsgErrorCommon)
            }
        }
    }
    
    func activeBet(paramters : [String : Any]?, _ completeHander: @escaping ((_ success : Bool , _ data : BaseModel<DataListModel>?,  _ message : String)->())){
        ApiAdmin.shared.activeBet(paramters: paramters) { (data) in
            if let data = data , data.status == true {
                completeHander(true , data , data.message ?? kMsgSuccessCommon)
            }else {
                completeHander(false , nil , data?.message ?? kMsgErrorCommon)
            }
        }
    }
    
}
