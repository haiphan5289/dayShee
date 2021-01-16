//
//  BannerAdv.swift
//  Dayshee
//
//  Created by paxcreation on 12/30/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

struct BannerAdv: Codable {
    let id: Int?
    let dataDescription, image: String?
    let video, link: String?
    let position: String?
    let createdAt, updatedAt: String?
    let imageURL: String?
    let videoURL: String?

    enum CodingKeys: String, CodingKey {
        case id
        case dataDescription = "description"
        case image, video, link, position
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case imageURL = "image_url"
        case videoURL = "video_url"
    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        dataDescription = try values.decodeIfPresent(String.self, forKey: .dataDescription)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        video = try values.decodeIfPresent(String.self, forKey: .video)
        link = try values.decodeIfPresent(String.self, forKey: .link)
        position = try values.decodeIfPresent(String.self, forKey: .position)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        imageURL = try values.decodeIfPresent(String.self, forKey: .imageURL)
        videoURL = try values.decodeIfPresent(String.self, forKey: .videoURL)
    }
}
