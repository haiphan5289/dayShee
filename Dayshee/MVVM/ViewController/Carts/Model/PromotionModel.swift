//
//  PromotionModel.swift
//  Dayshee
//
//  Created by haiphan on 11/11/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

struct PromotionModel: Codable {
    let id: Int?
    let promotionCode: String?
    let discount: Double?
    let startDate, endDate: String?

    enum CodingKeys: String, CodingKey {
        case id
        case promotionCode = "promotion_code"
        case discount
        case startDate = "start_date"
        case endDate = "end_date"
    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        promotionCode = try values.decodeIfPresent(String.self, forKey: .promotionCode)
        discount = try values.decodeIfPresent(Double.self, forKey: .discount)
        startDate = try values.decodeIfPresent(String.self, forKey: .startDate)
        endDate = try values.decodeIfPresent(String.self, forKey: .endDate)
    }
}

