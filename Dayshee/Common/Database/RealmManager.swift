//
//  RealmModel.swift
//  iKanBid
//
//  Created by Quân on 7/23/19.
//  Copyright © 2019 TVT25. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class RealmManager {
    
    static var shared = RealmManager()
    var realm : Realm!
    
    init() {
        migrateWithCompletion()
        realm = try! Realm()
    }
    
    func migrateWithCompletion() {
        let config = RLMRealmConfiguration.default()
        config.schemaVersion = 7
        
        config.migrationBlock = { (migration, oldSchemaVersion) in
            if (oldSchemaVersion < 1) {
                // Nothing to do!
                // Realm will automatically detect new properties and removed properties
                // And will update the schema on disk automatically
            }
        }
        
        RLMRealmConfiguration.setDefault(config)
        print("schemaVersion after migration:\(RLMRealmConfiguration.default().schemaVersion)")
        RLMRealm.default()
    }
    
    func get() -> [ProductsInRealm]{
        let arr = realm.objects(ProductsInRealm.self).toArray(ofType: ProductsInRealm.self)
        return arr
    }
    func getCart() -> [CartProductsInRealm]{
        let arr = realm.objects(CartProductsInRealm.self).toArray(ofType: CartProductsInRealm.self)
        return arr
    }
    func getAddressDefault() -> [AddressDefaultInRealm] {
        return realm.objects(AddressDefaultInRealm.self).toArray(ofType: AddressDefaultInRealm.self)
    }
    
    func getProduct() -> [ProductModel]{
        let arr = realm.objects(ProductsInRealm.self).toArray(ofType: ProductsInRealm.self)
        print(arr)
        var datas:[ProductModel] = []
        for item in arr {
          guard var model = item.product?.toCodableObject() as ProductModel? else{
              return []
          }
          model.quantity = item.quantity
          model.key = item.key
          model.id = item.id
          
          datas.append(model)
        }
        return datas
    }
    
    func getCartProduct() -> [HomeDetailModel]{
        let arr = realm.objects(CartProductsInRealm.self).toArray(ofType: CartProductsInRealm.self)
        print(arr)
        var datas:[HomeDetailModel] = []
        for item in arr {
            guard var model = item.product?.toCodableObject() as HomeDetailModel? else{
              return []
          }
        model.count = item.count
        model.productOptionID = item.productOptionID
        model.size = item.size
        model.productOtionPrice = item.productOptionPrice
        datas.append(model)
        }
        return datas
    }
  
    func getTotalPrice() -> Double {
        let datas = self.getProduct()
        var total = 0.0
        for data in datas {
            guard let product = data as ProductModel?, let properties = product.properties, properties.count > 0, let proper = properties[product.propertieIndex ?? 0] as Property?, let options = proper.options  else {
                return total
            }
            if options.count > 0 {
                total += Double(options[data.optionIndex ?? 0].price!) * Double(data.quantity!)
            }
        }
        return total
    }
    
    
    func getBadge() -> Results<Badge>{
        let badge = realm.objects(Badge.self)
        return badge
    }
    
    // Từ Update quantity ứng với index
    func update(_ item: ProductsInRealm, _ index: Int) {
        let realmPro = realm.objects(ProductsInRealm.self).toArray(ofType: ProductsInRealm.self)
        try! realm.write {
            realmPro[index].quantity = item.quantity
            NotificationCenter.default.post(name: NSNotification.Name(PushNotificationKeys.didUpdateCart.rawValue), object: nil, userInfo: nil)
        }
    }
    
    func updateCart(item: CartProductsInRealm, index: Int) {
        let realmPro = realm.objects(CartProductsInRealm.self).toArray(ofType: CartProductsInRealm.self)
        try! realm.write {
            realmPro[index].count += item.count
            NotificationCenter.default.post(name: NSNotification.Name(PushNotificationKeys.didUpdateCartProduct.rawValue), object: nil, userInfo: nil)
        }
    }
    
    
    // Update quantity ứng với productKey
    func updateQuantity(productKey: String, quantity: Int) {
        let items = get()
        if let index = items.firstIndex(where: {$0.key == productKey}) {
            try! realm.write {
                items[index].quantity = quantity
                NotificationCenter.default.post(name: NSNotification.Name(PushNotificationKeys.didUpdateCart.rawValue), object: nil, userInfo: nil)
            }
        }
    }
    
    
    
    // Update quantity ứng với productKey
    func replaceCartProduct(product: ProductModel, productKey: String) {
        var items = get()
        if let index = items.firstIndex(where: {$0.key == productKey}) {
            try! realm.write {
                let newValue = ProductsInRealm.init(product)
                print(newValue)
                items[index] = newValue//ProductsInRealm.init(product)
                NotificationCenter.default.post(name: NSNotification.Name(PushNotificationKeys.didUpdateCart.rawValue), object: nil, userInfo: nil)
            }
        }
    }
    // Update quantity ứng với productID
    func replaceCartProductCart(product: HomeDetailModel, productID: Int) {
        var items = getCart()
        if let index = items.firstIndex(where: {$0.productOptionID == productID}) {
            try! realm.write {
                let newValue = CartProductsInRealm.init(model: product)
                items[index] = newValue//ProductsInRealm.init(product)
                NotificationCenter.default.post(name: NSNotification.Name(PushNotificationKeys.didUpdateCartProduct.rawValue), object: nil, userInfo: nil)
            }
        }
    }
    
    
    func updateBadge(_ item: Badge) {
        if let badge = realm.objects(Badge.self).first {
            try! realm.write {
                badge.badgeValue += item.badgeValue
            }
        }
        
    }
    
    func insert(_ item: ProductsInRealm) {
        
        try! realm.write {
            realm.add(item)
            NotificationCenter.default.post(name: NSNotification.Name(PushNotificationKeys.didUpdateCart.rawValue), object: nil, userInfo: nil)
        }
    }
    func insertCart( item: CartProductsInRealm) {
        try! realm.write {
            realm.add(item)
            NotificationCenter.default.post(name: NSNotification.Name(PushNotificationKeys.didUpdateCartProduct.rawValue), object: nil, userInfo: nil)
        }
    }
    
    func insertLocation(item: LocationRealm) {
        try! realm.write {
            realm.add(item)
        }
    }
    
    func getListLocation() -> [Location]? {
        let arr = realm.objects(LocationRealm.self).toArray(ofType: LocationRealm.self)
        var datas:[Location] = []
        for item in arr {
            guard let model = item.location?.toCodableObject() as Location? else{
              return []
          }
          datas.append(model)
        }
        return datas
    }
    
    func insertBadge(_ item: Badge) {
        try! realm.write {
            realm.add(item)
        }
    }
    
    func delete(_ item: ProductsInRealm ) {
        let items = get()
        if let index = items.firstIndex(where: {$0.key == item.key}) {
            try! realm.write {
                realm.delete(items[index])
                NotificationCenter.default.post(name: NSNotification.Name(PushNotificationKeys.didUpdateCart.rawValue), object: nil, userInfo: nil)
            }
        }
    }
    func deleteCart(item: HomeDetailModel ) {
        let items = getCart()
        
        guard let id = item.productOptionID else {
            return
        }
        if let index = items.firstIndex(where: {$0.productOptionID == id}) {
            try! realm.write {
                realm.delete(items[index])
                NotificationCenter.default.post(name: NSNotification.Name(PushNotificationKeys.didUpdateCartProduct.rawValue), object: nil, userInfo: nil)
            }
        }
    }
    func deleteCarAll() {
        let items = getCart()
        try! realm.write {
            realm.delete(items)
            NotificationCenter.default.post(name: NSNotification.Name(PushNotificationKeys.didUpdateCartProduct.rawValue), object: nil, userInfo: nil)
        }
    }
    
    func insertOrUpdateProduct(_ model: ProductModel, quantity : Int, showBanner: Bool = true) {
        let items = get()
        if let index = items.firstIndex(where: {$0.id == model.id && $0.option_index == model.optionIndex && $0.color_index == model.propertieIndex}) {
            try! realm.write {
                items[index].quantity += quantity
                NotificationCenter.default.post(name: NSNotification.Name(PushNotificationKeys.didUpdateCart.rawValue), object: nil, userInfo: nil)
            }
        } else {
            let itemAdd = ProductsInRealm.init(model)
            itemAdd.quantity = quantity
            itemAdd.key = NSUUID().uuidString
            insert(itemAdd)
        }
    }
    func insertOrUpdateProduct(model: HomeDetailModel, count : Int) {
        let items = getCart()
        
        guard let id = model.productOptionID else {
            return
        }
        
        if let index = items.firstIndex(where: {$0.productOptionID == id }) {
            try! realm.write {
                items[index].count += count
                NotificationCenter.default.post(name: NSNotification.Name(PushNotificationKeys.didUpdateCartProduct.rawValue), object: nil, userInfo: nil)
            }
        } else {
            let itemAdd = CartProductsInRealm.init(model: model)
            itemAdd.count = count
            insertCart(item: itemAdd)
        }
    }
    
    func insertOrUpdateAddressDefault(model: AddressDefault) {
        let items = getAddressDefault()

        if let first = items.first {
            try! realm.write {
                first.addressDefault = try? model.toData()
            }
        } else {
            let item = AddressDefaultInRealm(model: model)
            try! realm.write {
                realm.add(item)
            }
        }
    }
    
    func removeAll() {
        try! realm.write {
            realm.deleteAll()
            NotificationCenter.default.post(name: NSNotification.Name(PushNotificationKeys.didUpdateCart.rawValue), object: nil, userInfo: nil)
            
        }
    }
    
    
}


extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        return array
    }
}


extension Object {
    func toDictionary() -> [String:Any] {
        let properties = self.objectSchema.properties.map { $0.name }
        var dicProps = [String:Any]()
        for (key, value) in self.dictionaryWithValues(forKeys: properties) {
            if let value = value as? ListBase {
                dicProps[key] = value.toArray()
            } else if let value = value as? Object {
                dicProps[key] = value.toDictionary()
            } else {
                dicProps[key] = value
            }
        }
        return dicProps
    }
}

extension ListBase {
    func toArray() -> [Any] {
        var _toArray = [Any]()
        for i in 0..<self._rlmArray.count {
            if let value = self._rlmArray[i] as? Object {
                let obj = unsafeBitCast(self._rlmArray[i], to: Object.self)
                _toArray.append(obj.toDictionary())
            } else {
                _toArray.append(self._rlmArray[i])
            }
            
        }
        return _toArray
    }
}
