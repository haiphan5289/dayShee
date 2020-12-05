//
//  DeliveryMode.swift
//  Dayshee
//
//  Created by paxcreation on 11/13/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

struct DeliveryMode: Codable {
    let id: Int?
    let delivery, time: String?
    let price: Double?
    
    enum CodingKeys: String, CodingKey {
        case id
        case delivery = "delivery"
        case time = "time"
        case price = "price"
    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        delivery = try values.decodeIfPresent(String.self, forKey: .delivery)
        time = try values.decodeIfPresent(String.self, forKey: .time)
        price = try values.decodeIfPresent(Double.self, forKey: .price)
        
    }
}
