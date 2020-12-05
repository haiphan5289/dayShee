//
//  ActionViewModel.swift
//  Knowitall
//
//  Created by thanhnguyen on 4/16/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import Foundation
class ActionViewModel {
    
    func actionConfirm(paramters : [String : Any]?, _ completeHander: @escaping ((_ success : Bool , _ data : BaseModel<DataListModel>?,  _ message : String)->())){
        ApiAction.shared.actionConfirm(paramters: paramters) { (data) in
            if let data = data , data.status == true {
                completeHander(true , data , data.message ?? kMsgSuccessCommon)
            }else {
                completeHander(false , nil , data?.message ?? kMsgErrorCommon)
            }
        }
    }
    
    func actionDecide(paramters : [String : Any]?, _ completeHander: @escaping ((_ success : Bool , _ data : BaseModel<DataListModel>?,  _ message : String)->())){
        ApiAction.shared.actionDecide(paramters:  paramters ){ (data) in
            if let data = data , data.status == true {
                completeHander(true , data , data.message ?? kMsgSuccessCommon)
            }else {
                completeHander(false , nil , data?.message ?? kMsgErrorCommon)
            }
        }
    }
    
    func actionJoin(paramters : [String : Any]?, _ completeHander: @escaping ((_ success : Bool , _ data : BaseModel<DataListModel>?,  _ message : String)->())){
        ApiAction.shared.actionJoin(paramters:  paramters ){ (data) in
            if let data = data , data.status == true {
                completeHander(true , data , data.message ?? kMsgSuccessCommon)
            }else {
                completeHander(false , nil , data?.message ?? kMsgErrorCommon)
            }
        }
    }
    
    
    
    func actionCloseBet(_ betId :Int ,paramters : [String : Any]?, _ completeHander: @escaping ((_ success : Bool , _ data : BaseModel<DataListModel>?,  _ message : String)->())){
        ApiAction.shared.actionCloseBet(betId: betId, paramters: paramters) { (data) in
            if let data = data , data.status == true {
                completeHander(true , data , data.message ?? kMsgSuccessCommon)
            }else {
                completeHander(false , nil , data?.message ?? kMsgErrorCommon)
            }
        }
    }
   
}
