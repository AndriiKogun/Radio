//
//  NSObject+Extension.swift
//  Partizan_test
//
//  Created by Andrii on 29.11.2021.
//

import Foundation

extension NSObject {
    
    class var className: String {
        return String(describing: self)
    }
}
