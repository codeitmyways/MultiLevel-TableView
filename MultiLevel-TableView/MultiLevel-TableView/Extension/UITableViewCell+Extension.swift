//
//  UITableViewCell+Extension.swift
//  DesiLux
//
//  Created by Sumit meena on 05/04/20.
//  Copyright © 2020 Sumit Meena. All rights reserved.
//

import Foundation
import UIKit

protocol NameDescribable {
    var typeName: String { get }
    static var typeName: String { get }
    static var identifier: String { get }
    static var nib: UINib { get }
}

extension NameDescribable {
    var typeName: String {
        return String(describing: type(of: self))
    }
    static var typeName: String {
        return String(describing: self)
    }
    static var identifier: String {
        return String(describing: self)
    }
    static var nib: UINib {
        return UINib(nibName: self.typeName, bundle: nil)
    }
}
extension UITableViewCell: NameDescribable {}

