//
//  KipleAPIV2.swift
//  Kiple
//
//  Created by Dong Nguyen on 8/2/17.
//  Copyright © 2017 com.futurify.vn. All rights reserved.
//

import Alamofire

class APIServices: NSObject {
    
    static let shared = APIServices()
    
    //MARK SUBDOMAIN
    
    func login(parameters : [String : Any]?, completion: @escaping ((_ model: BaseModel<UserModel>?)->Void)) {
        let url = "http://yelp-test.kennjdemo.com/api/v1/user/login"
        RequestService.shared.requestWith(url, .post, parameters, nil, objectType: BaseModel<UserModel>.self, encoding: JSONEncoding.default) { (data) in
            guard let model = data as? BaseModel<UserModel> else{
                completion(nil)
                return
            }
            completion(model)
        }
    }
    
    
}

