//
//  NotificationModel.swift
//  Dayshee
//
//  Created by paxcreation on 12/9/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

struct ListNotificationModel: Codable {
    let currentPage: Int?
    let data: [NotificationModel]?
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
        data = try values.decodeIfPresent([NotificationModel].self, forKey: .data)
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
struct NotificationModel: Codable {
    let id, userID, dataID, notificationTypeID: Int?
    let isRead: Bool?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case dataID = "data_id"
        case notificationTypeID = "notification_type_id"
        case isRead = "is_read"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        userID = try values.decodeIfPresent(Int.self, forKey: .userID)
        dataID = try values.decodeIfPresent(Int.self, forKey: .dataID)
        notificationTypeID = try values.decodeIfPresent(Int.self, forKey: .notificationTypeID)
        isRead = try values.decodeIfPresent(Bool.self, forKey: .isRead)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
    }
}

