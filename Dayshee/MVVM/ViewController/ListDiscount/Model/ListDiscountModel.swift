//
//  ListDiscountModel.swift
//  Dayshee
//
//  Created by haiphan on 11/19/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

// MARK: - DataClass
struct ListDiscountModel: Codable {
    let currentPage: Int?
    let data: [DiscountModel]?
    let firstPageURL: String?
    let from, lastPage: Int?
    let lastPageURL: String?
    let nextPageURL: String?
    let path: String?
    let perPage: String?
    let prevPageURL: String?
    let to, total: Int?

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
        data = try values.decodeIfPresent([DiscountModel].self, forKey: .data)
        firstPageURL = try values.decodeIfPresent(String.self, forKey: .firstPageURL)
        from = try values.decodeIfPresent(Int.self, forKey: .from)
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
struct DiscountModel: Codable {
    let id, categoryID: Int?
    let title, slug: String?
    let videoURL: String?
    let shortDescription, datumDescription: String?
    let isActive: Bool?
    let startDate, endDate: String?
    let imageURL: String?
    let category: CategoryListDiscount?
    let postImages: [String]?
    let products: [Product]?

    enum CodingKeys: String, CodingKey {
        case id
        case categoryID = "category_id"
        case title, slug
        case videoURL = "video_url"
        case shortDescription = "short_description"
        case datumDescription = "description"
        case isActive = "is_active"
        case startDate = "start_date"
        case endDate = "end_date"
        case imageURL = "image_url"
        case category
        case postImages = "post_images"
        case products
    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        categoryID = try values.decodeIfPresent(Int.self, forKey: .categoryID)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        videoURL = try values.decodeIfPresent(String.self, forKey: .videoURL)
        shortDescription = try values.decodeIfPresent(String.self, forKey: .shortDescription)
        datumDescription = try values.decodeIfPresent(String.self, forKey: .datumDescription)
        isActive = try values.decodeIfPresent(Bool.self, forKey: .isActive)
        startDate = try values.decodeIfPresent(String.self, forKey: .startDate)
        endDate = try values.decodeIfPresent(String.self, forKey: .endDate)
        imageURL = try values.decodeIfPresent(String.self, forKey: .imageURL)
        category = try values.decodeIfPresent(CategoryListDiscount.self, forKey: .category)
        postImages = try values.decodeIfPresent([String].self, forKey: .postImages)
        products = try values.decodeIfPresent([Product].self, forKey: .products)
    }

}

// MARK: - Category
struct CategoryListDiscount: Codable {
    let id: Int
    let category: String
}
