//
//  File.swift
//  Dayshee
//
//  Created by haiphan on 11/21/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

// MARK: - DataClass
struct OrderInfo: Codable {
    let id, userID: Int?
    let name, phone, address: String?
    let provinceID, districtID, wardID, deliveryID: Int?
    let subTotal, total: Double?
    let promotionCode: String?
    let promotionMoney, discountMoney, discount: Double?
    let qrCode: String?
    let note: String?
    let createdAt, updatedAt: String?
    let promotionPercent: Double?
    let orderStatus: OrderStatus?
    let province: Province?
    let district: District?
    let ward: Ward?
    let orderDetails: [OrderDetail]?
    let orderStatuses: [OrderStatus]?
    let delivery: DeliveryMode?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case name, phone, address
        case provinceID = "province_id"
        case districtID = "district_id"
        case wardID = "ward_id"
        case deliveryID = "delivery_id"
        case subTotal = "sub_total"
        case total
        case promotionMoney = "promotion_money"
        case promotionCode = "promotion_code"
        case discountMoney = "discount_money"
        case discount
        case qrCode = "qr_code"
        case note
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case promotionPercent = "promotion_percent"
        case orderStatus = "order_status"
        case province, district, ward
        case orderDetails = "order_details"
        case orderStatuses = "order_statuses"
        case delivery
    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        userID = try values.decodeIfPresent(Int.self, forKey: .userID)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        provinceID = try values.decodeIfPresent(Int.self, forKey: .provinceID)
        districtID = try values.decodeIfPresent(Int.self, forKey: .districtID)
        wardID = try values.decodeIfPresent(Int.self, forKey: .wardID)
        deliveryID = try values.decodeIfPresent(Int.self, forKey: .deliveryID)
        subTotal = try values.decodeIfPresent(Double.self, forKey: .subTotal)
        total = try values.decodeIfPresent(Double.self, forKey: .total)
        promotionMoney = try values.decodeIfPresent(Double.self, forKey: .promotionMoney)
        promotionCode = try values.decodeIfPresent(String.self, forKey: .promotionCode)
        discountMoney = try values.decodeIfPresent(Double.self, forKey: .discountMoney)
        discount = try values.decodeIfPresent(Double.self, forKey: .discount)
        qrCode = try values.decodeIfPresent(String.self, forKey: .qrCode)
        note = try values.decodeIfPresent(String.self, forKey: .note)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        promotionPercent = try values.decodeIfPresent(Double.self, forKey: .promotionPercent)
        orderStatus = try values.decodeIfPresent(OrderStatus.self, forKey: .orderStatus)
        province = try values.decodeIfPresent(Province.self, forKey: .province)
        district = try values.decodeIfPresent(District.self, forKey: .district)
        ward = try values.decodeIfPresent(Ward.self, forKey: .ward)
        orderDetails = try values.decodeIfPresent([OrderDetail].self, forKey: .orderDetails)
        orderStatuses = try values.decodeIfPresent([OrderStatus].self, forKey: .orderStatuses)
        delivery = try values.decodeIfPresent(DeliveryMode.self, forKey: .delivery)
    }
}

