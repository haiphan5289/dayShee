//
//  ProductHomeModel.swift
//  Dayshee
//
//  Created by paxcreation on 12/25/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

// MARK: - Datum
struct ProductHomeModel: Codable {
    let id: Int?
//    let categoryID: In?
    let category: String?
    let iconURL: String?
    let hotProducts, products: [Product]?

    enum CodingKeys: String, CodingKey {
        case id
//        case categoryID = "category_id"
        case category
        case iconURL = "icon_url"
        case hotProducts = "hot_products"
        case products
    }
//    public init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        id = try values.decodeIfPresent(Int.self, forKey: .id)
//        category = try values.decodeIfPresent(String.self, forKey: .category)
//        iconURL = try values.decodeIfPresent(String.self, forKey: .iconURL)
//        products = try values.decodeIfPresent([Product].self, forKey: .products)
//        hotProducts = try values.decodeIfPresent([Product].self, forKey: .hotProducts)
//    }
}

