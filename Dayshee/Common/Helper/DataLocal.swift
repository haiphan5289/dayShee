//
//  DataLocal.swift
//  Dayshee
//
//  Created by paxcreation on 11/2/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

class DataLocal {
    public static var share = DataLocal()
    var filterMode: FilterMode?
    var isFirstLocationView: Bool = false
    var isUpdateProvince: Bool = false
}
