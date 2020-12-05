//
//  LocalizableService.swift
//  iNails
//
//  Created by ThanhPham on 5/11/18.
//  Copyright © 2018 TVT25. All rights reserved.
//

import Foundation


enum Language: String {
    case vn
    case en
    case vi
}


let DynamicLanguageServiceDidDetectLanguageSwitchNotificationKey = "DynamicLanguageServiceDidDetectLanguageSwitchNotificationKey"


func localized(_ key: String) -> String {
    return LanguageService.service.dynamicLocalizedString(key)
}

class LanguageService {
    
    private struct Defaults {
        static let keyCurrentLanguage = "KeyCurrentLanguage"
    }
    
    static let service:LanguageService = LanguageService()
    
    var languageCode: String {
        get {
            return language.rawValue
        }
    }
    
    var defaultLanguageForLearning:Language {
        get {
            var language: Language = .vn
            if Token().current_language == language.rawValue {
                language = .en
            }
            return language
        }
    }
    
    func switchToLanguage(_ lang:Language) {
        language = lang
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: DynamicLanguageServiceDidDetectLanguageSwitchNotificationKey), object: nil)
    }
    
    func clearLanguages() {
        var tok = Token()
        tok.current_language = nil
    }
    
    private var localeBundle:Bundle?
    
    fileprivate var language: Language = Language.en {
        didSet {
            let currentLanguage = language
            var lang = Token()
            lang.current_language = currentLanguage.rawValue
            setLocaleWithLanguage(currentLanguage.rawValue)
        }
    }
    
    // MARK: - LifeCycle
    
    private init() {
        prepareDefaultLocaleBundle()
    }
    
    //MARK: - Private
    
    fileprivate func dynamicLocalizedString(_ key: String) -> String {
        var localizedString = key
        if let bundle = localeBundle {
            localizedString = NSLocalizedString(key, bundle: bundle, comment: "")
        } else {
            localizedString = NSLocalizedString(key, comment: "")
        }
        return localizedString
    }
    
    private func prepareDefaultLocaleBundle() {
        let tok = Token()
        guard let currentLanguage = tok.current_language else {
            return
        }
        
        updateCurrentLanguageWithName(currentLanguage)
        
    }
    
    private func updateCurrentLanguageWithName(_ languageName: String) {
        if let lang = Language(rawValue: languageName) {
            language = lang
        }
    }
    
    private func setLocaleWithLanguage(_ selectedLanguage: String) {
        if let pathSelected = Bundle.main.path(forResource: selectedLanguage, ofType: "lproj"),
            let bundleSelected = Bundle(path: pathSelected)  {
            localeBundle = bundleSelected
        } else if let pathDefault = Bundle.main.path(forResource: Language.en.rawValue, ofType: "lproj"),
            let bundleDefault = Bundle(path: pathDefault) {
            localeBundle = bundleDefault
        }
    }
}

protocol Localizable {
    func localizeUI()
}
