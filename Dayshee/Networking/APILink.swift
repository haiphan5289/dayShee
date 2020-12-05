//
//  APILink.swift
//  Dayshee
//
//  Created by haiphan on 10/31/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit

enum APILink: String {
    case register = "/user/register"
    case location = "/location"
    case profile = "/user/profile"
    case login = "/user/login"
    case banner = "/banner"
    case category = "/category"
    case product = "/product"
    case promotion = "/promotion"
    case delivery = "/delivery"
    case order = "/order"
    case rate = "/product/rate"
    case forgotPassword = "/user/forgot-password/check-phone"
    case newPass = "/user/password"
    case logOut = "/user/logout"
    case faq = "/product/faq"
    case addAddress = "/address"
    case updateAddress = "/address/update"
    case checkPhone = "/user/check-phone"
    case updateProfile = "/user/update"
    case tradeMark = "/trademark"
    case updateDefaultAddress = "/address/default"
    case cancelOrder = "/order/cancel"
    
    var value: String {
        return "\(self)"
    }
}
