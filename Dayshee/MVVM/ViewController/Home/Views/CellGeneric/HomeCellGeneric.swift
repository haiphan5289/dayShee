//
//  HomeCellGeneric.swift
//  Dayshee
//
//  Created by paxcreation on 11/4/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

protocol DisplayStaticHeightProtocol {
    static var height: CGFloat { get  }
    static var bottom: CGFloat { get }
    static var automaticHeight: Bool { get }
}

private class CachedNib {
    static let shard = CachedNib()
    private var views: [String: UINib] = [:]
    private let queue = DispatchQueue(label: "dayshe.loadNib", qos: .background)
    func load<T: UIView>() -> T {
        let key = "\(T.self)"
        if let result = views[key]?.instantiate(withOwner: nil, options: nil).first as? T {
            return result
        } else {
            let nib = T.nib
            views[key] = nib
            guard let result = queue.sync(execute: { nib?.instantiate(withOwner: nil, options: nil).first as? T }) else {
                fatalError("Please implement!!!")
            }
            return result
        }
    }
}
class HomeCellGeneric<T: UIView>: UITableViewCell, UpdateDisplayProtocol where T: UpdateDisplayProtocol, T: DisplayStaticHeightProtocol {
    func setupDisplay(item: T.Value?) {
        self.view.setupDisplay(item: item)
    }
    
    typealias Value = T.Value
    let view: T = CachedNib.shard.load()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        guard newSuperview != nil else {
            return
        }
        common()
    }
    
    private func common() {
//        selectionStyle = .none
        clipsToBounds = true
        contentView.clipsToBounds = true
        contentView.addSubview(view)
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        view.setContentHuggingPriority(.required, for: .vertical)
        view.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            if !T.automaticHeight {
                make.height.equalTo(T.height)
            }
            make.bottom.equalTo(T.bottom).priority(.high)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}


class CategoryCellGeneric<T: UIView>: UICollectionViewCell, UpdateDisplayProtocol where T: UpdateDisplayProtocol, T: DisplayStaticHeightProtocol {
    func setupDisplay(item: T.Value?) {
        self.view.setupDisplay(item: item)
    }
    
    typealias Value = T.Value
    let view: T = CachedNib.shard.load()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        guard newSuperview != nil else {
            return
        }
        common()
    }
    
    private func common() {
//        selectionStyle = .none
        clipsToBounds = true
        contentView.clipsToBounds = true
        contentView.addSubview(view)
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        view.setContentHuggingPriority(.required, for: .vertical)
        view.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            if !T.automaticHeight {
                make.height.equalTo(T.height)
            }
            make.bottom.equalTo(T.bottom).priority(.high)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
