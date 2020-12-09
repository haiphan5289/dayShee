//
//  CategoryVM.swift
//  Dayshee
//
//  Created by haiphan on 11/22/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

class CategoryVM: ActivityTrackingProgressProtocol {
    func filterMode(list: [Product], filter: FilterMode) -> [Product] {
        guard filter.minPrice != nil else {
            return list
        }
        return list
            .filter { ($0.maxPrice ?? 0) >= (filter.minPrice ?? 0) }
            .filter { ($0.maxPrice ?? 0) <= (filter.maxPrice ?? 0) }
    }
    func searchAndFilterMode(list: [Product], filter: FilterMode, textSearch: String) -> [Product] {
        guard filter.minPrice != nil else {
            return list.filter { ($0.name?.lowercased().contains(textSearch.lowercased()) ?? false) }
        }
        return list
            .filter { ($0.maxPrice ?? 0) >= (filter.minPrice ?? 0) }
            .filter { ($0.maxPrice ?? 0) <= (filter.maxPrice ?? 0) }
            .filter { ($0.name?.lowercased().contains(textSearch.lowercased()) ?? false) }
    }

    
}
