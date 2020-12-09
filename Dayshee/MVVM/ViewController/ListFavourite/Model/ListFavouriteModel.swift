//
//  ListFavouriteModel.swift
//  Dayshee
//
//  Created by paxcreation on 12/9/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

struct ListFavouriteModel: Codable {
    let currentPage: Int?
    let data: [FavouriteModel]?
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
        data = try values.decodeIfPresent([FavouriteModel].self, forKey: .data)
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
