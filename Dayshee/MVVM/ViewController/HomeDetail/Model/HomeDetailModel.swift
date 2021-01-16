//
//  HomeDetailMode.swift
//  Dayshee
//
//  Created by haiphan on 11/9/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

struct HomeDetailModel: Codable {
    let id: Int?
    let categoryID, originID, trademarkID: Int?
    let name, slug, shortDescription, dataDescription: String?
    let manuals: String?
    let isHot: Bool?
    let sku: String?
    let isActive: Bool?
    let relatedProducts: [Product]?
    let minPrice, maxPrice: Double?
    let imageURL: String?
    let category: CategoryHome?
    let origin: Origin?
    let trademark: Trademark?
    let productImages: [ProductImageDetail]?
    let productOptions: [ProductOption]?
    let productRatings: [ProductRating]?
    let productFaqs: [ProductFAQ]?
    var selectOption: ProductOption?
    {
        didSet {
            self.productOptionID = selectOption?.id
            self.productOtionPrice = selectOption?.price
        }
    }
    var productOptionID: Int?
    var productOtionPrice: Double?
    var count: Int?
    var size: String?
    let isFavourite: Bool?
    let rating: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case categoryID = "category_id"
        case originID = "origin_id"
        case trademarkID = "trademark_id"
        case name, slug
        case shortDescription = "short_description"
        case dataDescription = "description"
        case manuals
        case isHot = "is_hot"
        case sku
        case isActive = "is_active"
        case relatedProducts = "related_products"
        case minPrice = "min_price"
        case maxPrice = "max_price"
        case imageURL = "image_url"
        case category, origin, trademark
        case productImages = "product_images"
        case productOptions = "product_options"
        case productRatings = "product_ratings"
        case productFaqs = "product_faqs"
        case isFavourite = "is_favourite"
        case rating
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
        dataDescription = try values.decodeIfPresent(String.self, forKey: .dataDescription)
        manuals = try values.decodeIfPresent(String.self, forKey: .manuals)
        isHot = try values.decodeIfPresent(Bool.self, forKey: .isHot)
        sku = try values.decodeIfPresent(String.self, forKey: .sku)
        isActive = try values.decodeIfPresent(Bool.self, forKey: .isActive)
        relatedProducts = try values.decodeIfPresent([Product].self, forKey: .relatedProducts)
        minPrice = try values.decodeIfPresent(Double.self, forKey: .minPrice)
        maxPrice = try values.decodeIfPresent(Double.self, forKey: .maxPrice)
        imageURL = try values.decodeIfPresent(String.self, forKey: .imageURL)
        category = try values.decodeIfPresent(CategoryHome.self, forKey: .category)
        origin = try values.decodeIfPresent(Origin.self, forKey: .origin)
        trademark = try values.decodeIfPresent(Trademark.self, forKey: .trademark)
        productImages = try values.decodeIfPresent([ProductImageDetail].self, forKey: .productImages)
        productOptions = try values.decodeIfPresent([ProductOption].self, forKey: .productOptions)
        productRatings = try values.decodeIfPresent([ProductRating].self, forKey: .productRatings)
        productFaqs = try values.decodeIfPresent([ProductFAQ].self, forKey: .productFaqs)
        isFavourite = try values.decodeIfPresent(Bool.self, forKey: .isFavourite)
        rating = try values.decodeIfPresent(Double.self, forKey: .rating)
    }
}


// MARK: - ProductFAQ
struct ProductFAQ: Codable {
    let id, userID, productID: Int?
    let question, answer: String?
    let status: Bool?
    let createdAt, updatedAt: String?
    let product: Product?
    let user: UserDetail?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case productID = "product_id"
        case question, answer, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case product, user
    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        userID = try values.decodeIfPresent(Int.self, forKey: .userID)
        productID = try values.decodeIfPresent(Int.self, forKey: .productID)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        question = try values.decodeIfPresent(String.self, forKey: .question)
        answer = try values.decodeIfPresent(String.self, forKey: .answer)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        product = try values.decodeIfPresent(Product.self, forKey: .product)
        user = try values.decodeIfPresent(UserDetail.self, forKey: .user)
        
    }
}

enum Size: String, Codable {
    case the25Ml = "25ml"
    case the50Ml = "50ml"
    case the75Ml = "75ml"
}

// MARK: - User
struct UserDetail: Codable {
    let id: Int?
    let name, avatarURL: String?
    let level: Int?

    enum CodingKeys: String, CodingKey {
        case id, name
        case avatarURL = "avatar_url"
        case level
    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        avatarURL = try values.decodeIfPresent(String.self, forKey: .avatarURL)
        level = try values.decodeIfPresent(Int.self, forKey: .level)
    }
}

// MARK: - ProductImage
struct ProductImageDetail: Codable {
    let id, productID: Int?
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case imageURL = "image_url"
    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        productID = try values.decodeIfPresent(Int.self, forKey: .productID)
        imageURL = try values.decodeIfPresent(String.self, forKey: .imageURL)
    }
}

// MARK: - ProductRating
struct ProductRating: Codable {
    let id, userID, productID: Int?
    let rating: Double?
    let comment: String?
    let isActive: Bool?
    let createdAt: String?
    let product: Product?
    let user: User?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case productID = "product_id"
        case rating, comment
        case isActive = "is_active"
        case createdAt = "created_at"
        case product, user
    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        userID = try values.decodeIfPresent(Int.self, forKey: .userID)
        productID = try values.decodeIfPresent(Int.self, forKey: .productID)
        rating = try values.decodeIfPresent(Double.self, forKey: .rating)
        comment = try values.decodeIfPresent(String.self, forKey: .comment)
        isActive = try values.decodeIfPresent(Bool.self, forKey: .isActive)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        product = try values.decodeIfPresent(Product.self, forKey: .product)
        user = try values.decodeIfPresent(User.self, forKey: .user)
    }
}

