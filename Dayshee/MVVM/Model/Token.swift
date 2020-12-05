//
//  Token.swift
//  Kiple
//
//  Created by ThanhPham on 8/3/17.
//  Copyright © 2017 com.futurify.vn. All rights reserved.
//

import Foundation


struct Token {
    
    fileprivate let userDefaults: UserDefaults
    
    var email: String? {
        get {
            return userDefaults.string(forKey: UserDefaultKey.kEmail.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: UserDefaultKey.kEmail.rawValue)
            userDefaults.synchronize()
        }
    }
    
    var password: String? {
        get {
            return userDefaults.string(forKey: UserDefaultKey.kPassword.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: UserDefaultKey.kPassword.rawValue)
            userDefaults.synchronize()
        }
    }
    
    var token: String? {
        get {
            return userDefaults.string(forKey: UserDefaultKey.kAccessToken.rawValue) ?? ""
        }
        set {
            userDefaults.set(newValue, forKey: UserDefaultKey.kAccessToken.rawValue)
            userDefaults.synchronize()
        }
    }
    
    var tokenExists: Bool {
        
        guard let token = self.token, token.count > 0 else {
            return false
        }
        return true
    }
    
    var user: UserInfo? {
        get {
            return self.readUserDefault(offtype: UserInfo.self, key: UserDefaultKey.kCurUser.rawValue)
        }
        set {
            self.inputUserDefault(ofType: newValue, key: UserDefaultKey.kCurUser.rawValue)
            userDefaults.synchronize()
        }
    }
    
    var current_language: String? {
        get {
            return userDefaults.string(forKey: "UserDefaultKey.kLanguage.rawValue") ?? "vi"
        }
        set {
            userDefaults.set(newValue, forKey: "UserDefaultKey.kLanguage.rawValue")
            userDefaults.synchronize()
        }
    }
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    init() {
        self.userDefaults = UserDefaults.standard
    }
    
    func clear() {
        for key in UserDefaultKey.allCases {
            userDefaults.removeObject(forKey: key.rawValue)
            userDefaults.synchronize()
        }
        
    }
    func inputUserDefault<T: Encodable>(ofType type: T, key: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(type) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: key)
        }
    }
    func readUserDefault<T: Codable>(offtype type: T.Type, key: String) -> T? {
        let defaults = UserDefaults.standard
        if let savedPerson = defaults.object(forKey: key) as? Data {
            let decoder = JSONDecoder()
            do {
                let loadedPerson = try decoder.decode(T.self, from: savedPerson)
                return loadedPerson
            } catch let err {
                print(err.localizedDescription)
            }
        }
        return UserInfo.self as? T
    }
}

