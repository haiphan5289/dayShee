//
//  ListOrderModel.swift
//  Dayshee
//
//  Created by haiphan on 11/21/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//


struct OrderPaging: Codable {
    let currentPage: Int?
    let data: [OrderModel]?
    let firstPageURL: String?
    let from, lastPage: Int?
    let lastPageURL, nextPageURL, path: String?
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
        data = try values.decodeIfPresent([OrderModel].self, forKey: .data)
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

// MARK: - Datum
struct OrderModel: Codable {
    let id, userID: Int?
    let name: String?
    let phone: String?
    let address: String?
    let provinceID, districtID, wardID, deliveryID: Int?
    let subTotal, total: Double?
    let promotionMoney: Double?
    let promotionCode: String?
    let discountMoney, discount: Double?
    let qrCode: String?
    let note: String?
    let createdAt, updatedAt: String?
    let promotionPercent: Double?
    let orderStatus: OrderStatus?
    let products: [Product]?

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
        case products
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
        products = try values.decodeIfPresent([Product].self, forKey: .products)
    }
}



// MARK: - OrderStatus
struct OrderStatus: Codable {
    let id, orderID, status: Int?
    let reason: String?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case orderID = "order_id"
        case status, reason
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        orderID = try values.decodeIfPresent(Int.self, forKey: .orderID)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        reason = try values.decodeIfPresent(String.self, forKey: .reason)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        
    }
}

