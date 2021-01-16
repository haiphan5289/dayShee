//
//  ProvinceOrderModel.swift
//  Dayshee
//
//  Created by paxcreation on 1/12/21.
//  Copyright © 2021 ThanhPham. All rights reserved.
//

struct ProvinceOrderModel: Codable {
    let id: Int?
    let levelID: Double?
    let name, phone: String?
    let email: String?
    let address: String?
    let orderProvinceID, wardID, districtID, provinceID: Int?
    let birthday: String?
    let points: Int?
    let isActive, notify: Bool?
    let code: String?
    let avatarURL: String?
    let orderProvince: OrderProvince?
    //    let level: JSONNull?
    
    enum CodingKeys: String, CodingKey {
        case id
        case levelID = "level_id"
        case name, phone, email, address
        case orderProvinceID = "order_province_id"
        case wardID = "ward_id"
        case districtID = "district_id"
        case provinceID = "province_id"
        case birthday, points
        case isActive = "is_active"
        case notify, code
        case avatarURL = "avatar_url"
        case orderProvince = "order_province"
        //        case level
    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        levelID = try values.decodeIfPresent(Double.self, forKey: .levelID)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        orderProvinceID = try values.decodeIfPresent(Int.self, forKey: .orderProvinceID)
        wardID = try values.decodeIfPresent(Int.self, forKey: .wardID)
        districtID = try values.decodeIfPresent(Int.self, forKey: .districtID)
        provinceID = try values.decodeIfPresent(Int.self, forKey: .provinceID)
        birthday = try values.decodeIfPresent(String.self, forKey: .birthday)
        points = try values.decodeIfPresent(Int.self, forKey: .points)
        isActive = try values.decodeIfPresent(Bool.self, forKey: .isActive)
        notify = try values.decodeIfPresent(Bool.self, forKey: .notify)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        avatarURL = try values.decodeIfPresent(String.self, forKey: .avatarURL)
        orderProvince = try values.decodeIfPresent(OrderProvince.self, forKey: .orderProvince)
    }
}

// MARK: - OrderProvince
struct OrderProvince: Codable {
    let id: Int?
    let type, province: String?
    let latitude, longitude: Double?
//    let createdAt, updatedAt: JSONNull?

    enum CodingKeys: String, CodingKey {
        case id, type, province, latitude, longitude
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        latitude = try values.decodeIfPresent(Double.self, forKey: .latitude)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        province = try values.decodeIfPresent(String.self, forKey: .province)
        longitude = try values.decodeIfPresent(Double.self, forKey: .longitude)
       
    }
}
