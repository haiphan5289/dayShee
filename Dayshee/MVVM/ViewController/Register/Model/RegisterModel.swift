//
//  RegisterModel.swift
//  Dayshee
//
//  Created by haiphan on 10/31/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit

struct UserInfo: Codable {
    let id: Int?
    let levelID: Int?
    let level: Level?
    let name: String?
    let phone: String?
    let email: String?
    let address: String?
    let wardID: Int?
    let districtID: Int?
    let provinceID: Int?
    let birthday: String?
    let points: Int?
    let isActive: Bool?
    let notify: Bool?
    let token: String?
    let avatarURL: String?
    var isAgency: Bool {
        return (level != nil ) ? true : false
    }

    enum CodingKeys: String, CodingKey {
        case id
        case level = "level"
        case levelID = "level_id"
        case name, phone, email, address
        case wardID = "ward_id"
        case districtID = "district_id"
        case provinceID = "province_id"
        case birthday, points
        case isActive = "is_active"
        case notify, token
        case avatarURL = "avatar_url"
    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        levelID = try values.decodeIfPresent(Int.self, forKey: .levelID)
        level = try values.decodeIfPresent(Level.self, forKey: .level)
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
        token = try values.decodeIfPresent(String.self, forKey: .token)
        avatarURL = try values.decodeIfPresent(String.self, forKey: .avatarURL)
    }
}
struct Level: Codable {
    let id: Int?
    let level: String?
    let points: Double?
    let discount: Double?
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case level = "level"
        case points = "points"
        case discount = "discount"
    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        level = try values.decodeIfPresent(String.self, forKey: .level)
        points = try values.decodeIfPresent(Double.self, forKey: .points)
        discount = try values.decodeIfPresent(Double.self, forKey: .discount)
    }
}

struct Location: Codable {
    let id: Int?
    let type: LocationType?
    let province: String?
    let createdAt: String?
    let updatedAt: String?
    let districts: [District]?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case type = "type"
        case province = "province"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case districts
    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        type = try values.decodeIfPresent(LocationType.self, forKey: .type)
        province = try values.decodeIfPresent(String.self, forKey: .province)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        districts = try values.decodeIfPresent([District].self, forKey: .districts)
    }
    
}

// MARK: - District
struct District: Codable {
    let id, provinceID: Int?
    let type: DistrictType?
    let district: String?
    let wards: [Ward]?

    enum CodingKeys: String, CodingKey {
        case id
        case provinceID = "province_id"
        case type, district, wards
    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        provinceID = try values.decodeIfPresent(Int.self, forKey: .provinceID)
        type = try values.decodeIfPresent(DistrictType.self, forKey: .type)
        wards = try values.decodeIfPresent([Ward].self, forKey: .wards)
        district = try values.decodeIfPresent(String.self, forKey: .district)
    }
}

enum DistrictType: String, Codable {
    case District = "Huyện"
    case Township = "Quận"
    case City = "Thành phố"
    case Town = "Thị xã"
}

// MARK: - Ward
struct Ward: Codable {
    let id, districtID: Int?
    let type: WardType?
    let ward: String?

    enum CodingKeys: String, CodingKey {
        case id
        case districtID = "district_id"
        case type, ward
    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        districtID = try values.decodeIfPresent(Int.self, forKey: .districtID)
        type = try values.decodeIfPresent(WardType.self, forKey: .type)
        ward = try values.decodeIfPresent(String.self, forKey: .ward)
    }
}

enum WardType: String, Codable {
    case Ward = "Phường"
    case Township = "Thị trấn"
    case Town = "Xã"
}

enum LocationType: String, Codable {
    case Centrality = "Thành phố Trung ương"
    case Provincial = "Tỉnh"
}


struct RegisterTemp {
    var name: String?
    var phone: String?
    var address: String?
    var zone: Int?
    var district: Int?
    var ward: Int?
    var birthday: String?
    var dataImages: [UIImagePickerController.InfoKey : Any]?
    var url: String?
    var id: Int?
}

struct AddressDefault: Codable {
    var name: String?
    var phone: String?
    var address: String?
    var zone: Int?
    {
        didSet {
            if let list = RealmManager.shared.getListLocation(), list.count > 0 {
                self.nameZone = "kokokoko"
            }
        }
    }
    var nameZone: String?
    var district: Int?
    var nameDistrict: String?
    var ward: Int?
    var nameWard: String?
}
