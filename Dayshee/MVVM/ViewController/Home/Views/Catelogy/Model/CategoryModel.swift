//
//  CategoryModel.swift
//  Dayshee
//
//  Created by haiphan on 11/5/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//


struct CategoryHome: Codable {
    let id: Int?
    let categoryID: Int?
    let category: String?
    let iconURL: String?

    enum CodingKeys: String, CodingKey {
        case id
        case categoryID = "category_id"
        case category
        case iconURL = "icon_url"
    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        categoryID = try values.decodeIfPresent(Int.self, forKey: .categoryID)
        category = try values.decodeIfPresent(String.self, forKey: .category)
        iconURL = try values.decodeIfPresent(String.self, forKey: .iconURL)
    }
}
