//
//  RuleEureka.swift
//  Dayshee
//
//  Created by haiphan on 10/31/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import Eureka

public struct RuleRowValid: RuleType {

    let isValid: Bool

    public var id: String?
    public var validationError: ValidationError

    public init(isValid: Bool, msg: String? = nil){
        let ruleMsg = msg ?? "Field value must have at least \(isValid) characters"
        self.isValid = isValid
        validationError = ValidationError(msg: ruleMsg)
    }

    public func isValid(value: Bool?) -> ValidationError? {
        guard let value = value else { return nil }
        return (value == self.isValid) ? nil : validationError
    }
}
public struct RuleMinLength: RuleType {

    let min: UInt

    public var id: String?
    public var validationError: ValidationError

    public init(minLength: UInt, msg: String? = nil){
        let ruleMsg = msg ?? "Field value must have at least \(minLength) characters"
        min = minLength
        validationError = ValidationError(msg: ruleMsg)
    }

    public func isValid(value: String?) -> ValidationError? {
        guard let value = value else { return nil }
        return value.count < Int(min) ? validationError : nil
    }
}
