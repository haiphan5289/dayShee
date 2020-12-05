//
//  Array+Extension.swift
//  iKanBid
//
//  Created by ThanhPham on 5/21/19.
//  Copyright © 2019 TVT25. All rights reserved.
//

import Foundation


extension Array {
    /// Returns an array containing this sequence shuffled
    var shuffled: Array {
        var elements = self
        return elements.shuffle()
    }
    /// Shuffles this sequence in place
    @discardableResult
    
    mutating func shuffle() -> Array {
        let count = self.count
        indices.lazy.dropLast().forEach {
            guard case let index = Int(arc4random_uniform(UInt32(count - $0))) + $0, index != $0 else { return }
            self.swapAt($0, index)
        }
        return self
    }
    
    var chooseOne: Element { return self[Int(arc4random_uniform(UInt32(count)))] }
    
    func choose(_ n: Int) -> Array { return Array(shuffled.prefix(n)) }
}
