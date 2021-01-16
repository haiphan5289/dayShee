//
//  BannerModel.swift
//  Dayshee
//
//  Created by haiphan on 11/5/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

//const TYPE_PRODUCT = 1;
//    const TYPE_PROMOTION = 2;
//    const TYPE_VIDEO = 3;

enum TypeBanner: Int {
    case typeProduct = 1
    case typePromotion = 2
    case typeVideo = 3
}

struct Banner: Codable {
    let id: Int?
    let productID: Int?
    let startDate: String?
    let endDate: String?
    let type: Int?
    let isPopup: Int?
    let text: String?
    let datumDescription: String?
    let bannerURL: String?

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case text
        case datumDescription = "description"
        case startDate = "start_date"
        case endDate = "end_date"
        case type
        case isPopup = "is_popup"
        case bannerURL = "banner_url"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        productID = try values.decodeIfPresent(Int.self, forKey: .productID)
        text = try values.decodeIfPresent(String.self, forKey: .text)
        datumDescription = try values.decodeIfPresent(String.self, forKey: .datumDescription)
        bannerURL = try values.decodeIfPresent(String.self, forKey: .bannerURL)
        startDate = try values.decodeIfPresent(String.self, forKey: .startDate)
        endDate = try values.decodeIfPresent(String.self, forKey: .endDate)
        type = try values.decodeIfPresent(Int.self, forKey: .type)
        isPopup = try values.decodeIfPresent(Int.self, forKey: .isPopup)
    }
}
