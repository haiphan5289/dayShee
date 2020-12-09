//
//  ListProductStream.swift
//  Dayshee
//
//  Created by haiphan on 11/8/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import RxCocoa
import RxSwift

class ListProductStream  {
    static var share = ListProductStream()
    var totalProduct: ProductHome?
    var listCategory: [CategoryHome] = []
    var listHotProduct: [Product] = []
    var listDiscountProduct: [Product] = []
    
    func getListCategoryHotProduct(categoryID: Int) -> [Product]? {
        guard let list = self.getListProductWithCaterogy(categoryID: categoryID) else {
            return nil
        }
        let listCategoryHot = list.filter({ (prooduct) -> Bool in
            return prooduct.isHot == true
        })
        return listCategoryHot
    }
    func getListProductWithCaterogy(categoryID: Int) -> [Product]? {
        guard let total = self.totalProduct else {
            return nil
        }
        guard let list = total.data else {
            return nil
        }
        let listCate = list.filter({ (product) -> Bool in
            return product.category?.id == categoryID
        })
        return listCate
    }
    func getListProductTheSameTradeMark(tradeMarkID: Int) -> [Product]? {
        guard let total = self.totalProduct else {
            return nil
        }
        guard let list = total.data else {
            return nil
        }
        let listCate = list.filter({ (product) -> Bool in
            return product.trademarkID == tradeMarkID
        })
        return listCate
    }
    func getAllProduct() -> [Product] {
        guard let total = self.totalProduct else {
            return []
        }
        guard let list = total.data else {
            return []
        }
        return list
    }
    func getListAllHotProduct() -> [Product] {
        let listCategoryHot = self.getAllProduct().filter({ (p) -> Bool in
            return p.isHot == true
        })
        return listCategoryHot
    }
    func getListSale(list: [ProductOption]) -> Bool {
        var isSale: Bool = false
        list.forEach { (item) in
            guard let sale = item.isSale, sale == true else {
                isSale = false
                return
            }
            isSale = true
        }
        return isSale
    }
    func listDiscount() -> [Product] {
        return self.getAllProduct()
            .filter { (product) -> Bool in
                guard let l = product.productOptions else {
                    return false
                }
                return self.getListSale(list: l)
            }
    }
}
