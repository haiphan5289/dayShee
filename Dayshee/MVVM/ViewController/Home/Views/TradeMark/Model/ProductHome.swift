//
//  ProductModel.swift
//  Dayshee
//
//  Created by haiphan on 11/5/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

struct ProductHome: Codable {
    let currentPage: Int?
    let data: [Product]?
    let firstPageURL: String?
    let from: Int?
    let lastPage: Int?
    let lastPageURL: String?
    let nextPageURL: String?
    let path: String?
    let perPage: String?
    let prevPageURL: String?
    let to: Int?
    let total: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
        case firstPageURL = "first_page_url"
        case from
        case lastPage = "last_page"
        case lastPageURL = "last_page_url"
        case nextPageURL = "next_page_url"
        case path
        case perPage = "per_page"
        case prevPageURL = "prev_page_url"
        case to, total
    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        currentPage = try values.decodeIfPresent(Int.self, forKey: .currentPage)
        data = try values.decodeIfPresent([Product].self, forKey: .data)
        from = try values.decodeIfPresent(Int.self, forKey: .from)
        firstPageURL = try values.decodeIfPresent(String.self, forKey: .firstPageURL)
        lastPage = try values.decodeIfPresent(Int.self, forKey: .lastPage)
        lastPageURL = try values.decodeIfPresent(String.self, forKey: .lastPageURL)
        nextPageURL = try values.decodeIfPresent(String.self, forKey: .nextPageURL)
        path = try values.decodeIfPresent(String.self, forKey: .path)
        perPage = try values.decodeIfPresent(String.self, forKey: .perPage)
        prevPageURL = try values.decodeIfPresent(String.self, forKey: .prevPageURL)
        to = try values.decodeIfPresent(Int.self, forKey: .to)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
    }
}

// MARK: - Datum
struct Product: Codable {
    let id, categoryID, originID, trademarkID: Int?
    let name, slug, shortDescription, datumDescription: String?
    let manuals: String?
    let isHot: Bool?
    let sku: String?
    let isActive: Bool?
    let minPrice, maxPrice: Double?
    let imageURL: String?
    let category: CategoryHome?
    let origin: Origin?
    let trademark: Trademark?
    let productOptions: [ProductOption]?
    var count: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case categoryID = "category_id"
        case originID = "origin_id"
        case trademarkID = "trademark_id"
        case name, slug
        case shortDescription = "short_description"
        case datumDescription = "description"
        case manuals
        case isHot = "is_hot"
        case sku
        case isActive = "is_active"
        case minPrice = "min_price"
        case maxPrice = "max_price"
        case imageURL = "image_url"
        case category, origin, trademark
        case productOptions = "product_options"
    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        categoryID = try values.decodeIfPresent(Int.self, forKey: .categoryID)
        originID = try values.decodeIfPresent(Int.self, forKey: .originID)
        trademarkID = try values.decodeIfPresent(Int.self, forKey: .trademarkID)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        shortDescription = try values.decodeIfPresent(String.self, forKey: .shortDescription)
        datumDescription = try values.decodeIfPresent(String.self, forKey: .datumDescription)
        manuals = try values.decodeIfPresent(String.self, forKey: .manuals)
        isHot = try values.decodeIfPresent(Bool.self, forKey: .isHot)
        sku = try values.decodeIfPresent(String.self, forKey: .sku)
        isActive = try values.decodeIfPresent(Bool.self, forKey: .isActive)
        minPrice = try values.decodeIfPresent(Double.self, forKey: .minPrice)
        maxPrice = try values.decodeIfPresent(Double.self, forKey: .maxPrice)
        imageURL = try values.decodeIfPresent(String.self, forKey: .imageURL)
        category = try values.decodeIfPresent(CategoryHome.self, forKey: .category)
        origin = try values.decodeIfPresent(Origin.self, forKey: .origin)
        trademark = try values.decodeIfPresent(Trademark.self, forKey: .trademark)
        productOptions = try values.decodeIfPresent([ProductOption].self, forKey: .productOptions)
        
    }
}


// MARK: - Origin
struct Origin: Codable {
    let id: Int
    let origin: String
}

// MARK: - ProductOption
struct ProductOption: Codable {
    let id, productID: Int?
    let size: String?
    let color, material: String?
    let quantity, price: Double?
    let salePrice: Double?
    let isSale: Bool?
    let saleRate: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case size, color, material, quantity, price
        case salePrice = "sale_price"
        case isSale = "is_sale"
        case saleRate = "sale_rate"
    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        productID = try values.decodeIfPresent(Int.self, forKey: .productID)
        size = try values.decodeIfPresent(String.self, forKey: .size)
        color = try values.decodeIfPresent(String.self, forKey: .color)
        material = try values.decodeIfPresent(String.self, forKey: .material)
        salePrice = try values.decodeIfPresent(Double.self, forKey: .salePrice)
        isSale = try values.decodeIfPresent(Bool.self, forKey: .isSale)
        quantity = try values.decodeIfPresent(Double.self, forKey: .quantity)
        price = try values.decodeIfPresent(Double.self, forKey: .price)
        saleRate = try values.decodeIfPresent(Double.self, forKey: .saleRate)
    }
    
}

// MARK: - Trademark
struct Trademark: Codable {
    let id: Int?
    let trademark: String?
    enum CodingKeys: String, CodingKey {
        case id
        case trademark
    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        trademark = try values.decodeIfPresent(String.self, forKey: .trademark)
    }
}

