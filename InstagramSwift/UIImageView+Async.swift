//
//  UIImageView+Async.swift
//  InstagramSwift
//
//  Created by Daramony on 4/2/16.
//  Copyright © 2016 Daramony. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func loadImage(image : String) {
        let url = NSURL(string: image)
        self.image = nil
        self.image = UIImage(named: "gray")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let data = NSData(contentsOfURL: url!)
            dispatch_async(dispatch_get_main_queue(), {
                if data != nil {
                    self.image = UIImage(data: data!)
                }
            })
        }
    }
    
}
