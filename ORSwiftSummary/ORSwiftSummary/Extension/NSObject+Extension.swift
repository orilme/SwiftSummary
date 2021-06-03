//
//  NSObject+Extension.swift
//  ORSwiftSummary
//
//  Created by orilme on 2021/6/3.
//  Copyright © 2021 orilme. All rights reserved.
//

import UIKit

extension NSObject {
    public var className: String {
        return String(describing: type(of: self))
    }
    
    public class var className: String {
        return String(describing: self)
    }
}
