//
//  GiftCodeModel.swift
//  Dayshee
//
//  Created by paxcreation on 1/11/21.
//  Copyright © 2021 ThanhPham. All rights reserved.
//

// MARK: - DataClass
struct GiftCodePaging: Codable {
    let currentPage: Int?
    let data: [GiftCodeModel]?
    let firstPageURL: String?
    let from, lastPage: Int?
    let lastPageURL: String?
//    let nextPageURL: JSONNull?
    let path: String?
    let perPage: Int?
//    let prevPageURL: JSONNull?
    let to, total: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
        case firstPageURL = "first_page_url"
        case from
        case lastPage = "last_page"
        case lastPageURL = "last_page_url"
//        case nextPageURL = "next_page_url"
        case path
        case perPage = "per_page"
//        case prevPageURL = "prev_page_url"
        case to, total
    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        currentPage = try values.decodeIfPresent(Int.self, forKey: .currentPage)
        data = try values.decodeIfPresent([GiftCodeModel].self, forKey: .data)
        firstPageURL = try values.decodeIfPresent(String.self, forKey: .firstPageURL)
        from = try values.decodeIfPresent(Int.self, forKey: .from)
        lastPage = try values.decodeIfPresent(Int.self, forKey: .lastPage)
        lastPageURL = try values.decodeIfPresent(String.self, forKey: .lastPageURL)
        path = try values.decodeIfPresent(String.self, forKey: .path)
        perPage = try values.decodeIfPresent(Int.self, forKey: .perPage)
        to = try values.decodeIfPresent(Int.self, forKey: .to)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
    }
}
// MARK: - Datum
struct GiftCodeModel: Codable {
    let id: Int?
    let giftCode: String?
    let giftDiscount: Double?
    let giftMoney: Int?
    let startDate, endDate: String?
    let imageUrl: String?

    enum CodingKeys: String, CodingKey {
        case id
        case giftCode = "gift_code"
        case giftDiscount = "gift_discount"
        case giftMoney = "gift_money"
        case startDate = "start_date"
        case endDate = "end_date"
        case imageUrl = "image_url"
    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        giftCode = try values.decodeIfPresent(String.self, forKey: .giftCode)
        giftDiscount = try values.decodeIfPresent(Double.self, forKey: .giftDiscount)
        giftMoney = try values.decodeIfPresent(Int.self, forKey: .giftMoney)
        startDate = try values.decodeIfPresent(String.self, forKey: .startDate)
        endDate = try values.decodeIfPresent(String.self, forKey: .endDate)
        imageUrl = try values.decodeIfPresent(String.self, forKey: .imageUrl)
    }
}

