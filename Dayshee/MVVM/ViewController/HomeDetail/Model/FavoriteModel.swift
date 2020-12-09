//
//  FavoriteModel.swift
//  Dayshee
//
//  Created by haiphan on 12/8/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

struct FavouriteModel: Codable {
    let userID, productID: Int?
    let updatedAt, createdAt: String?
    let id: Int?
    let user: UserInfo?
    let product: Product?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case productID = "product_id"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case id, user, product
    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        userID = try values.decodeIfPresent(Int.self, forKey: .userID)
        productID = try values.decodeIfPresent(Int.self, forKey: .productID)
        user = try values.decodeIfPresent(UserInfo.self, forKey: .user)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        product = try values.decodeIfPresent(Product.self, forKey: .product)
    }
    
}
