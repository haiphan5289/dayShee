//
//  UserModel.swift
//  SnapChat
//
//  Created by admin on 5/13/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import Foundation

struct UserModel : Codable {
    
    var expires : Int?
    var token : String?
    var type : String?
    var user : User?
    
    init(from decoder: Decoder) throws {
        expires = try? decoder.decode("expires")
        token = try? decoder.decode("token")
        type = try? decoder.decode("type")
        user = try? decoder.decode("user")
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if expires != nil{
            dictionary["expires"] = expires
        }
        if token != nil{
            dictionary["token"] = token
        }
        if type != nil{
            dictionary["type"] = type
        }
        if user != nil{
            dictionary["user"] = user!.toDictionary()
        }
        return dictionary
    }
}

struct User : Codable {
    
    var avatar : String?
    var email : String?
    var name : String?
    var phone : String?
    var role_id : Int?
    var status : Int?
    var user_name : String?
    var address : String?
    var link_avatar : String?

    init(from decoder: Decoder) throws {
        avatar = try? decoder.decode("avatar")
        email = try? decoder.decode("email")
        name = try? decoder.decode("name")
        phone = try? decoder.decode("phone")
        role_id = try? decoder.decode("role_id")
        status = try? decoder.decode("status")
        user_name = try? decoder.decode("user_name")
        address = try? decoder.decode("address")
        link_avatar = try? decoder.decode("link_avatar")
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if avatar != nil{
            dictionary["avatar"] = avatar
        }
        if email != nil{
            dictionary["email"] = email
        }
        if name != nil{
            dictionary["name"] = name
        }
        if phone != nil{
            dictionary["phone"] = phone
        }
        if role_id != nil{
            dictionary["role_id"] = role_id
        }
        if status != nil{
            dictionary["status"] = status
        }
        if user_name != nil{
            dictionary["user_name"] = user_name
        }
        if address != nil{
            dictionary["address"] = address
        }
      if link_avatar != nil{
          dictionary["link_avatar"] = link_avatar
      }
        return dictionary
    }
}
