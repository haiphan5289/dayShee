//
//  NotificationViewModel.swift
//  Knowitall
//
//  Created by thanhnguyen on 4/13/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import Foundation

class NotificationViewModel {
    
    func notifi(paramters : [String : Any]?, _ completeHander: @escaping ((_ success : Bool , _ data : BaseListModel<NotifiModel>?,  _ message : String)->())){
        ApiNotifi.shared.notifi(paramters: paramters) { (data) in
            if let data = data , data.status == true {
                completeHander(true , data , data.message ?? kMsgSuccessCommon)
            }else {
                completeHander(false , nil , data?.message ?? kMsgErrorCommon)
            }
        }
    }
    
}
