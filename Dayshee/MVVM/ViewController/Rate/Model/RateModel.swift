//
//  RateModel.swift
//  Dayshee
//
//  Created by haiphan on 11/15/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

struct RateModel: Codable {
    let userID, productID, rating: Int?
    let comment: String?
    let isActive: Bool?
    let createdAt: String?
    let id: Int?
    let product: Product?
    let user: UserInfo?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case productID = "product_id"
        case rating, comment
        case isActive = "is_active"
        case createdAt = "created_at"
        case id, product, user
    }
}
