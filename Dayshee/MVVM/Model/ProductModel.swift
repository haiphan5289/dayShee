//
//  ProductModel.swift
//  Ayofa
//
//  Created by admin on 3/10/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import Foundation

struct CategoryModel : Codable {
    var count : Int?
    var id : Int?
    var image : String?
    var link_image : String?
    var name : String?
    
    init(from decoder: Decoder) throws {
        count = try? decoder.decode("count")
        id = try? decoder.decode("id")
        image = try? decoder.decode("image")
        link_image = try? decoder.decode("link_image")
        name = try? decoder.decode("name")
    }
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if count != nil{
            dictionary["count"] = count
        }
        if id != nil{
            dictionary["id"] = id
        }
        if image != nil{
            dictionary["image"] = image
        }
        if link_image != nil{
            dictionary["link_image"] = link_image
        }
        if name != nil{
            dictionary["name"] = name
        }
        return dictionary
    }
}

//struct ProductModel : Codable {
//
//    var category_id : Int?
//    var category_name : String?
//    var created_at : String?
//    var description : String?
//    var discounted_price : String?
//    var id : Int?
//    var image : String?
//    var options : [Option]?
//    var price : Double?
//    var product_name : String?
//    var product_status : Int?
//    var link_image : String?
//    var properties : [Property]?
//    var updated_at : String?
//    var property_name : String?
//    var option_name : String?
//Extra
//    var quantity : Int?
//    var key: String?
var propertieIndex: Int?
var optionIndex: Int?
//
//    var product_id: Int?
//    var product_option_id: Int?
//    var product_property_id: Int?

//    init(from decoder: Decoder) throws {
//        category_id = try? decoder.decode("category_id")
//        category_name = try? decoder.decode("category_name")
//        created_at = try? decoder.decode("created_at")
//        description = try? decoder.decode("description")
//        discounted_price = try? decoder.decode("discounted_price")
//        id = try? decoder.decode("id")
//        image = try? decoder.decode("image")
//        options = try? decoder.decode("options")
//        price = try? decoder.decode("price")
//        product_name = try? decoder.decode("product_name")
//        product_status = try? decoder.decode("product_status")
//        properties = try? decoder.decode("properties")
//        updated_at = try? decoder.decode("updated_at")
//        quantity = try? decoder.decode("quantity")
//        key = try? decoder.decode("key")
//        link_image = try? decoder.decode("link_image")
//        propertieIndex = try? decoder.decode("propertieIndex")
//        optionIndex = try? decoder.decode("optionIndex")
//        property_name = try? decoder.decode("property_name")
//        option_name = try? decoder.decode("option_name")
//      product_option_id = try? decoder.decode("product_option_id")
//      product_property_id = try? decoder.decode("product_property_id")
//      product_id = try? decoder.decode("product_id")
//
//    }
//
//    /**
//     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
//     */
//    func toDictionary() -> [String:Any]
//    {
//        var dictionary = [String:Any]()
//        if option_name != nil{
//            dictionary["option_name"] = option_name
//        }
//        if property_name != nil{
//            dictionary["property_name"] = property_name
//        }
//        if propertieIndex != nil{
//            dictionary["propertieIndex"] = propertieIndex
//        }
//        if optionIndex != nil{
//            dictionary["optionIndex"] = optionIndex
//        }
//        if quantity != nil{
//            dictionary["quantity"] = quantity
//        }
//        if key != nil{
//            dictionary["key"] = key
//        }
//        if category_id != nil{
//            dictionary["category_id"] = category_id
//        }
//        if category_name != nil{
//            dictionary["category_name"] = category_name
//        }
//        if created_at != nil{
//            dictionary["created_at"] = created_at
//        }
//        if description != nil{
//            dictionary["description"] = description
//        }
//        if discounted_price != nil{
//            dictionary["discounted_price"] = discounted_price
//        }
//        if id != nil{
//            dictionary["id"] = id
//        }
//        if image != nil{
//            dictionary["image"] = image
//        }
//        if options != nil{
//            dictionary["options"] = options
//        }
//        if price != nil{
//            dictionary["price"] = price
//        }
//        if product_name != nil{
//            dictionary["product_name"] = product_name
//        }
//        if product_status != nil{
//            dictionary["product_status"] = product_status
//        }
//        if properties != nil{
//            dictionary["properties"] = properties
//        }
//        if updated_at != nil{
//            dictionary["updated_at"] = updated_at
//        }
//        return dictionary
//    }
//}
//
//struct Property : Codable {
//
//    var color : String?
//    var color_code : String?
//    var id : Int?
//    var image : String?
//    var link_image : String?
//    var quantity : Int?
//
//    init(from decoder: Decoder) throws {
//        color = try? decoder.decode("color")
//        color_code = try? decoder.decode("color_code")
//        id = try? decoder.decode("id")
//        image = try? decoder.decode("image")
//        link_image = try? decoder.decode("link_image")
//        quantity = try? decoder.decode("quantity")
//    }
//
//    /**
//     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
//     */
//    func toDictionary() -> [String:Any]
//    {
//        var dictionary = [String:Any]()
//        if color != nil{
//            dictionary["color"] = color
//        }
//        if color_code != nil{
//            dictionary["color_code"] = color_code
//        }
//        if id != nil{
//            dictionary["id"] = id
//        }
//        if image != nil{
//            dictionary["image"] = image
//        }
//        if quantity != nil{
//            dictionary["quantity"] = quantity
//        }
//        return dictionary
//    }
//}
//
//struct Option : Codable {
//
//    var id : Int?
//    var option_name : String?
//    var price : Double?
//
//    init(from decoder: Decoder) throws {
//        id = try? decoder.decode("id")
//        option_name = try? decoder.decode("option_name")
//        price = try? decoder.decode("price")
//    }
//
//    /**
//     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
//     */
//    func toDictionary() -> [String:Any]
//    {
//        var dictionary = [String:Any]()
//        if id != nil{
//            dictionary["id"] = id
//        }
//        if option_name != nil{
//            dictionary["option_name"] = option_name
//        }
//        if price != nil{
//            dictionary["price"] = price
//        }
//        return dictionary
//    }
//}

struct ProductModel : Codable {
    
    var id : Int?
    var product_code : String?
    var product_name : String?
    var description : String?
    var category_id : Int?
    var image : String?
    var start_date_new_product : String?
    var end_date_new_product : String?
    var product_status : String?
    var created_at : String?
    var updated_at : String?
    var ListID : String?
    var EditSequence : String?
    var SalesPrice : String?
    var PurchaseCost : String?
    var QuantityOnHand : String?
    var QuantityOnSalesOrder : String?
    var SalesDesc : String?
    var IncomeAccountRef : String?
    var ManufacturerPartNumber : String?
    var queue_qb : Int?
    var link_image : String?
    var category_name : String?
    var properties : [Property]?
    var product_images : [ProductImage]?
    
    //Extra
    var quantity : Int?
    var key: String?
    var propertieIndex: Int?
    var optionIndex: Int?
    
    var product_id: Int?
    var product_option_id: Int?
    var product_property_id: Int?
    
    
    init(from decoder: Decoder) throws {
        id = try? decoder.decode("id")
        product_code = try? decoder.decode("product_code")
        product_name = try? decoder.decode("product_name")
        description = try? decoder.decode("description")
        category_id = try? decoder.decode("category_id")
        image = try? decoder.decode("image")
        start_date_new_product = try? decoder.decode("start_date_new_product")
        end_date_new_product = try? decoder.decode("end_date_new_product")
        product_status = try? decoder.decode("product_status")
        created_at = try? decoder.decode("created_at")
        updated_at = try? decoder.decode("updated_at")
        ListID = try? decoder.decode("ListID")
        EditSequence = try? decoder.decode("EditSequence")
        SalesPrice = try? decoder.decode("SalesPrice")
        PurchaseCost = try? decoder.decode("PurchaseCost")
        QuantityOnHand = try? decoder.decode("QuantityOnHand")
        QuantityOnSalesOrder = try? decoder.decode("QuantityOnSalesOrder")
        SalesDesc = try? decoder.decode("SalesDesc")
        IncomeAccountRef = try? decoder.decode("IncomeAccountRef")
        ManufacturerPartNumber = try? decoder.decode("ManufacturerPartNumber")
        queue_qb = try? decoder.decode("queue_qb")
        link_image = try? decoder.decode("link_image")
        category_name = try? decoder.decode("category_name")
        properties = try? decoder.decode("properties")
        product_images = try? decoder.decode("product_images")
        
        
        product_option_id = try? decoder.decode("product_option_id")
        product_property_id = try? decoder.decode("product_property_id")
        product_id = try? decoder.decode("product_id")
        
        quantity = try? decoder.decode("quantity")
        key = try? decoder.decode("key")
        propertieIndex = try? decoder.decode("propertieIndex")
        optionIndex = try? decoder.decode("optionIndex")
    }
}

class ProductImage : Codable {
    
    var image_product : String?
    init() {
    }
    required init(from decoder: Decoder) throws {
        image_product = try? decoder.decode("image_product")
    }
    
}

struct Property : Codable {
    
    var property_id : Int?
    var color : String?
    var color_code : String?
    var options : [Option]?
    
    init(from decoder: Decoder) throws {
        property_id = try? decoder.decode("property_id")
        color = try? decoder.decode("color")
        color_code = try? decoder.decode("color_code")
        options = try? decoder.decode("options")
    }
    
}

struct Option : Codable {
    
    var id : Int?
    var product_id : Int?
    var option_name : String?
    var inventory : Int?
    var property_id : Int?
    var link_image : String?
    var price : Int?
    var color : String?
    var color_code : String?
    
    init(from decoder: Decoder) throws {
        id = try? decoder.decode("id")
        product_id = try? decoder.decode("product_id")
        option_name = try? decoder.decode("option_name")
        inventory = try? decoder.decode("inventory")
        property_id = try? decoder.decode("property_id")
        link_image = try? decoder.decode("link_image")
        price = try? decoder.decode("price")
        color = try? decoder.decode("color")
        color_code = try? decoder.decode("color_code")
    }
}

//
//struct ProductModel : Codable {
//    var category_id : Int?
//    var category_name : String?
//    var created_at : String?
//    var description : String?
//    var end_date_new_product : String?
//    var id : Int?
//    var image : String?
//    var link_image : String?
//    var product_code : String?
//    var product_name : String?
//    var product_status : Int?
//    var properties : [Property]?
//    var start_date_new_product : String?
//    var updated_at : String?
//
//
//    //Extra
//    var quantity : Int?
//    var key: String?
//    var propertieIndex: Int?
//    var optionIndex: Int?
//
//    var product_id: Int?
//    var product_option_id: Int?
//    var product_property_id: Int?
//
//
//    init(from decoder: Decoder) throws {
//        category_id = try? decoder.decode("category_id")
//        category_name = try? decoder.decode("category_name")
//        created_at = try? decoder.decode("created_at")
//        description = try? decoder.decode("description")
//        end_date_new_product = try? decoder.decode("end_date_new_product")
//        id = try? decoder.decode("id")
//        image = try? decoder.decode("image")
//        link_image = try? decoder.decode("link_image")
//        product_code = try? decoder.decode("product_code")
//        product_name = try? decoder.decode("product_name")
//        product_status = try? decoder.decode("product_status")
//        properties = try? decoder.decode("properties")
//        start_date_new_product = try? decoder.decode("start_date_new_product")
//        updated_at = try? decoder.decode("updated_at")
//
//        product_option_id = try? decoder.decode("product_option_id")
//        product_property_id = try? decoder.decode("product_property_id")
//        product_id = try? decoder.decode("product_id")
//
//        quantity = try? decoder.decode("quantity")
//        key = try? decoder.decode("key")
//        propertieIndex = try? decoder.decode("propertieIndex")
//        optionIndex = try? decoder.decode("optionIndex")
//    }
//}
//
