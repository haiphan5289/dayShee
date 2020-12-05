//
//  BaseModel.swift
//  English4Kids
//
//  Created by Dong Nguyen on 5/10/18.
//  Copyright © 2018 Dong Nguyen. All rights reserved.
//

import Foundation

class BaseResponse: Codable {
    
    var result: Bool?
    var message: String?
    
    required init(from decoder: Decoder) throws {
        result = try? decoder.decode("result")
        message = try? decoder.decode("message")
    }
    
}

class BaseModel<T:Codable>: BaseResponse {
    var data: T?
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        data = try? decoder.decode("data")
    }
}

struct BaseListModel<T:Codable>: Codable {
    
    var status: String?
    var code: Int?
    var messager: String?
    var data: [T]?
    
    init(from decoder: Decoder) throws {
        messager = try? decoder.decode("messager")
        status = try? decoder.decode("status")
        data = try? decoder.decode("data")
        code = try? decoder.decode("code")
        
    }
}

struct BasePagingModel<T:Codable>: Codable {
    
    var status: String?
    var code: Int?
    var messager: String?
    var data: PagingModel<T>?
    var min_order_quantity: Int?

    init(from decoder: Decoder) throws {
        messager = try? decoder.decode("messager")
        code = try? decoder.decode("code")
        status = try? decoder.decode("status")
        data = try? decoder.decode("data")
        code = try? decoder.decode("code")
        min_order_quantity = try? decoder.decode("min_order_quantity")

    }
    
}

struct PagingModel<T:Codable>: Codable {
    
    var current_page : Int?
    var data : [T]?
    var first_page_url : String?
    var from : Int?
    var last_page : Int?
    var last_page_url : String?
    var next_page_url : String?
    var path : String?
    var per_page : Int?
    var prev_page_url : String?
    var to : Int?
    var total : Int?
    
    
    init(from decoder: Decoder) throws {
        current_page = try? decoder.decode("current_page")
        data = try? decoder.decode("data")
        first_page_url = try? decoder.decode("first_page_url")
        from = try? decoder.decode("from")
        last_page = try? decoder.decode("last_page")
        last_page_url = try? decoder.decode("last_page_url")
        next_page_url = try? decoder.decode("next_page_url")
        path = try? decoder.decode("path")
        per_page = try? decoder.decode("per_page")
        prev_page_url = try? decoder.decode("prev_page_url")
        to = try? decoder.decode("to")
        total = try? decoder.decode("total")
    }
}



