//
//  Contact.swift
//  Dayshee
//
//  Created by haiphan on 12/8/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

struct Contact: Codable {
    let userID: Int?
    let name, email, content, updatedAt: String?
    let createdAt: String?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case name, email, content
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case id
    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        userID = try values.decodeIfPresent(Int.self, forKey: .userID)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        content = try values.decodeIfPresent(String.self, forKey: .content)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
    }
}

