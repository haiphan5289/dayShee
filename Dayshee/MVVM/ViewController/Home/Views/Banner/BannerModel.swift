//
//  BannerModel.swift
//  Dayshee
//
//  Created by haiphan on 11/5/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

struct Banner: Codable {
    let id: Int?
    let text: String?
    let datumDescription: String?
    let sliderURL: String?

    enum CodingKeys: String, CodingKey {
        case id
        case text
        case datumDescription = "description"
        case sliderURL = "slider_url"
    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        text = try values.decodeIfPresent(String.self, forKey: .text)
        datumDescription = try values.decodeIfPresent(String.self, forKey: .datumDescription)
        sliderURL = try values.decodeIfPresent(String.self, forKey: .sliderURL)
    }
}
