//
//  SearchView.swift
//  Dayshee
//
//  Created by haiphan on 12/27/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SearchView: UIView, UpdateDisplayProtocol, DisplayStaticHeightProtocol {
    static var height: CGFloat { return 40 }
    static var bottom: CGFloat { return 0 }
    static var automaticHeight: Bool { return true }
    var moveToCategory:(() -> Void)?
    var filter:(() -> Void)?
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var btFilter: UIButton!
    private let tapTfSearch: UITapGestureRecognizer = UITapGestureRecognizer()
    private let disposeBag = DisposeBag()
}
extension SearchView: Weakifiable {
    override func awakeFromNib() {
        super.awakeFromNib()
        visualize()
        setupRX()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    override func removeFromSuperview() {
        superview?.removeFromSuperview()
    }
    
}
extension SearchView {
    func setupDisplay(item: [Product]?) {

    }
    
    private func setupRX() {
        self.tapTfSearch.rx.event.asObservable().bind(onNext: weakify({ (tap, wSelf) in
            wSelf.moveToCategory?()
        })).disposed(by: disposeBag)
        
        self.btFilter.rx.tap.bind(onNext: weakify({ (wSelf) in
            wSelf.filter?()
        })).disposed(by: disposeBag)
    }
    private func visualize() {
        tapTfSearch.cancelsTouchesInView = true
        self.tfSearch.addGestureRecognizer(tapTfSearch)
    }
}
