//
//  OrderCart.swift
//  Dayshee
//
//  Created by haiphan on 11/15/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

struct OrderCart: Codable {
    let id, userID: Int?
    let name, phone, address: String?
    let provinceID, districtID, wardID, deliveryID: Int?
    let subTotal, total, promotionMoney: Double?
    let promotionCode: String?
    let discountMoney, discount: Double?
    let qrCode, note, createdAt, updatedAt: String?
    let promotionPercent: Double?
    let delivery: DeliveryMode?
    let province: Province?
    let district: District?
    let ward: Ward?
    let orderDetails: [OrderDetail]?
    let expectedDeliveryAt: String?

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
        case delivery, province, district, ward
        case orderDetails = "order_details"
        case expectedDeliveryAt = "expected_delivery_at"
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
        delivery = try values.decodeIfPresent(DeliveryMode.self, forKey: .delivery)
        province = try values.decodeIfPresent(Province.self, forKey: .province)
        district = try values.decodeIfPresent(District.self, forKey: .district)
        ward = try values.decodeIfPresent(Ward.self, forKey: .ward)
        orderDetails = try values.decodeIfPresent([OrderDetail].self, forKey: .orderDetails)
        expectedDeliveryAt = try values.decodeIfPresent(String.self, forKey: .expectedDeliveryAt)
    }
}


// MARK: - OrderDetail
struct OrderDetail: Codable {
    let id, orderID, productID, productOptionID: Int?
    let price, quantity, discountMoney: Double?
    let discount: Double?
    let createdAt, updatedAt: String?
    let product: Product?

    enum CodingKeys: String, CodingKey {
        case id
        case orderID = "order_id"
        case productID = "product_id"
        case productOptionID = "product_option_id"
        case price, quantity
        case discountMoney = "discount_money"
        case discount
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case product
    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        orderID = try values.decodeIfPresent(Int.self, forKey: .orderID)
        productID = try values.decodeIfPresent(Int.self, forKey: .productID)
        productOptionID = try values.decodeIfPresent(Int.self, forKey: .productOptionID)
        price = try values.decodeIfPresent(Double.self, forKey: .price)
        quantity = try values.decodeIfPresent(Double.self, forKey: .quantity)
        discountMoney = try values.decodeIfPresent(Double.self, forKey: .discountMoney)
        discount = try values.decodeIfPresent(Double.self, forKey: .discount)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        product = try values.decodeIfPresent(Product.self, forKey: .product)
    }
}
struct Province: Codable {
    let id: Int?
    let type, province: String?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, type, province
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        province = try values.decodeIfPresent(String.self, forKey: .province)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
    }
}

struct AddressModel: Codable {
    var id, userID, provinceID, districtID: Int?
    var wardID: Int?
    var name, phone, address: String?
    var isDefault: Bool?
    let createdAt, updatedAt: String?
    let province: Province?
    let district: District?
    let ward: Ward?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case provinceID = "province_id"
        case districtID = "district_id"
        case wardID = "ward_id"
        case name, phone, address
        case isDefault = "is_default"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case province, district, ward
    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        userID = try values.decodeIfPresent(Int.self, forKey: .userID)
        provinceID = try values.decodeIfPresent(Int.self, forKey: .provinceID)
        districtID = try values.decodeIfPresent(Int.self, forKey: .districtID)
        wardID = try values.decodeIfPresent(Int.self, forKey: .wardID)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        isDefault = try values.decodeIfPresent(Bool.self, forKey: .isDefault)
        province = try values.decodeIfPresent(Province.self, forKey: .province)
        district = try values.decodeIfPresent(District.self, forKey: .district)
        ward = try values.decodeIfPresent(Ward.self, forKey: .ward)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
    }
}
struct ListAddress: Codable {
    let currentPage: Int?
    let data: [AddressModel]?
    let firstPageURL: String?
    let from, lastPage: Int?
    let lastPageURL: String?
    let nextPageURL: String?
    let path: String?
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
        data = try values.decodeIfPresent([AddressModel].self, forKey: .data)
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
