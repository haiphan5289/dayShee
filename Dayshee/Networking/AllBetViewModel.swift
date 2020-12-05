//
//  AllBetViewModel.swift
//  Knowitall
//
//  Created by thanhnguyen on 4/10/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import Foundation

class AllbetViewModel {
    
    func listBet(paramters : [String : Any]?, _ completeHander: @escaping ((_ success : Bool , _ data : BaseListModel<DataListModel>?,  _ message : String)->())){
        ApiAllbet.shared.listBet(paramters: paramters) { (data) in
            if let data = data , data.status == true {
                completeHander(true , data , data.message ?? kMsgSuccessCommon)
            }else {
                completeHander(false , nil , data?.message ?? kMsgErrorCommon)
            }
        }
    }
    
    
    func createBet(paramters : [String : Any]?, _ completeHander: @escaping ((_ success : Bool , _ data : BaseModel<DataListModel>?,  _ message : String)->())){
        ApiAllbet.shared.createBet(paramters: paramters) { (data) in
            if let data = data , data.status == true {
                completeHander(true , data , data.message ?? kMsgSuccessCommon)
            }else {
                completeHander(false , nil , data?.message ?? kMsgErrorCommon)
            }
        }
    }
    
    
//    func join(paramters : [String : Any]?, _ completeHander: @escaping ((_ success : Bool , _ data : BaseModel<DataListModel>?,  _ message : String)->())){
//        ApiAllbet.shared.action(paramters: paramters) { (data) in
//            if let data = data , data.status == true {
//                completeHander(true , data , data.message ?? kMsgSuccessCommon)
//            }else {
//                completeHander(false , nil , data?.message ?? kMsgErrorCommon)
//            }
//        }
//    }
    
    func betDetail(betId : Int, _ completeHander: @escaping ((_ success : Bool , _ data : BaseModel<DataListModel>?,  _ message : String)->())){
        ApiAllbet.shared.betDetail(betId: betId) { (data) in
            if let data = data , data.status == true {
                completeHander(true , data , data.message ?? kMsgSuccessCommon)
            }else {
                completeHander(false , nil , data?.message ?? kMsgErrorCommon)
            }
        }
    }
    
    
    func getUserJoin(paramters : [String : Any]?, _ completeHander: @escaping ((_ success : Bool , _ data : BasePagingModel<UsersJoined>?,  _ message : String)->())){
           ApiAllbet.shared.getUserJoin(paramters: paramters) { (data) in
               if let data = data , data.status == true {
                   completeHander(true , data , data.message ?? kMsgSuccessCommon)
               }else {
                   completeHander(false , nil , data?.message ?? kMsgErrorCommon)
               }
           }
       }
       
    
    func myBet(paramters : [String : Any]?, _ completeHander: @escaping ((_ success : Bool , _ data : BaseListModel<DataListModel>?,  _ message : String)->())){
           ApiAllbet.shared.myBet(paramters: paramters) { (data) in
               if let data = data , data.status == true {
                   completeHander(true , data , data.message ?? kMsgSuccessCommon)
               }else {
                   completeHander(false , nil , data?.message ?? kMsgErrorCommon)
               }
           }
       }
       
    
    func userDetail(userId:Int ,paramters : [String : Any]?, _ completeHander: @escaping ((_ success : Bool , _ data : BasePagingModel<DataListModel>?,  _ message : String)->())){
        ApiAllbet.shared.userDetail(userId: userId, paramters: paramters) { (data) in

            if let data = data , data.status == true {
                completeHander(true , data , data.message ?? kMsgSuccessCommon)
            }else {
                completeHander(false , nil , data?.message ?? kMsgErrorCommon)
            }
        }
    }
    
    
    
    func optionFollowBet(optionId: Int , _ completeHander: @escaping ((_ success : Bool , _ data : BaseListModel<DataUpdate>?,  _ message : String)->())){
        ApiAllbet.shared.optionFollowBet(optionId: optionId) { (data) in

            if let data = data , data.status == true {
                completeHander(true , data , data.message ?? kMsgSuccessCommon)
            }else {
                completeHander(false , nil , data?.message ?? kMsgErrorCommon)
            }
        }
    }
    
}
