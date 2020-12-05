
//
//  Utils.swift
//  Keng
//
//  Created by ThanhPham on 10/16/18.
//  Copyright © 2018 Dong Nguyen. All rights reserved.
//

import UIKit
import Foundation
import YPImagePicker

class Utils {
    
    static var shared = Utils()
    
    func showImagePicker(limit: Int, viewController: UIViewController) {
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = limit
        let picker = YPImagePicker(configuration: config)
        
        picker.didFinishPicking { [unowned picker] items, cancelled in
            for item in items {
                switch item {
                case .photo(let photo):
                    print(photo)
                case .video(let video):
                    print(video)
                }
            }
            picker.dismiss(animated: true, completion: nil)
        }
    }
}
