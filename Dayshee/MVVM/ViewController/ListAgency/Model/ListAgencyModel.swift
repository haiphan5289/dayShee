//
//  ListAgencyModel.swift
//  Dayshee
//
//  Created by haiphan on 12/26/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

struct ListAgencyModel: Codable {
    let id: Int?
    let type: String?
    let province: String?
    let latitude, longitude: Double?
//    let createdAt, updatedAt: S?
    let agencies: [Agency]?

    enum CodingKeys: String, CodingKey {
        case id, type, province, latitude, longitude
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
        case agencies
    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        province = try values.decodeIfPresent(String.self, forKey: .province)
        latitude = try values.decodeIfPresent(Double.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(Double.self, forKey: .longitude)
        agencies = try values.decodeIfPresent([Agency].self, forKey: .agencies)
    }
}

// MARK: - Agency
struct Agency: Codable {
    let id: Int?
    let levelID: Double?
    let code: String?
    let name, phone: String?
    let email: String?
    let address: String?
    let wardID, districtID, provinceID: Int?
    let birthday: String?
    let points: Int?
    let isActive, notify: Bool?
    let avatarURL: String?
//    let level: String?

    enum CodingKeys: String, CodingKey {
        case id
        case levelID = "level_id"
        case code, name, phone, email, address
        case wardID = "ward_id"
        case districtID = "district_id"
        case provinceID = "province_id"
        case birthday, points
        case isActive = "is_active"
        case notify
        case avatarURL = "avatar_url"
//        case level
    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        levelID = try values.decodeIfPresent(Double.self, forKey: .levelID)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        wardID = try values.decodeIfPresent(Int.self, forKey: .wardID)
        districtID = try values.decodeIfPresent(Int.self, forKey: .districtID)
        provinceID = try values.decodeIfPresent(Int.self, forKey: .provinceID)
        birthday = try values.decodeIfPresent(String.self, forKey: .birthday)
        points = try values.decodeIfPresent(Int.self, forKey: .points)
        isActive = try values.decodeIfPresent(Bool.self, forKey: .isActive)
        notify = try values.decodeIfPresent(Bool.self, forKey: .notify)
        avatarURL = try values.decodeIfPresent(String.self, forKey: .avatarURL)
//        level = try values.decodeIfPresent(String.self, forKey: .level)
    }
}
