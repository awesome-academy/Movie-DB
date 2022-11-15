//
//  UIView+.swift
//  MovieDB
//
//  Created by le.n.t.trung on 14/11/2022.
//

import Foundation
import UIKit

extension UIView {
    var identifier: String {
        return String(describing: type(of: self))
    }
    
    class var identifier: String {
        return String(describing: self)
    }
    
    func makeCornerRadius(_ value: Double) {
        clipsToBounds = true
        layer.cornerRadius = value
    }
}
