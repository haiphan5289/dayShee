//
//  HistoryBetViewModel.swift
//  Knowitall
//
//  Created by thanhnguyen on 4/13/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import Foundation

class HistoryBetViewModel {
    
    func myBetHistory(paramters : [String : Any]?, _ completeHander: @escaping ((_ success : Bool , _ data : BaseModel<DataListModel>?,  _ message : String)->())){
        ApiHistoryBet.shared.myBetHistory(paramters: paramters) { (data) in
            if let data = data , data.status == true {
                completeHander(true , data , data.message ?? kMsgSuccessCommon)
            }else {
                completeHander(false , nil , data?.message ?? kMsgErrorCommon)
            }
        }
    }
    
    func myBalanceToday(_ detailId :Int , _ completeHander: @escaping ((_ success : Bool , _ data : BaseModel<DataHistory>?,  _ message : String)->())){
        ApiHistoryBet.shared.myBalanceToday(detailId: detailId) { (data) in
            if let data = data , data.status == true {
                completeHander(true , data , data.message ?? kMsgSuccessCommon)
            }else {
                completeHander(false , nil , data?.message ?? kMsgErrorCommon)
            }
        }
    }
}
