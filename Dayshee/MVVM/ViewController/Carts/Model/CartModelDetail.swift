//
//  CartModel.swift
//  Dayshee
//
//  Created by paxcreation on 1/4/21.
//  Copyright © 2021 ThanhPham. All rights reserved.
//

// MARK: - DataClass
struct CartModelDetail: Codable {
    let subTotal, total, discountMoney, promotionMoney: Int?
    let promotionPercent: Int?
    let products: [Product]?

    enum CodingKeys: String, CodingKey {
        case subTotal = "sub_total"
        case total
        case discountMoney = "discount_money"
        case promotionMoney = "promotion_money"
        case promotionPercent = "promotion_percent"
        case products
    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        subTotal = try values.decodeIfPresent(Int.self, forKey: .subTotal)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
        discountMoney = try values.decodeIfPresent(Int.self, forKey: .discountMoney)
        promotionMoney = try values.decodeIfPresent(Int.self, forKey: .promotionMoney)
        promotionPercent = try values.decodeIfPresent(Int.self, forKey: .promotionPercent)
        products = try values.decodeIfPresent([Product].self, forKey: .products)
    }
}
