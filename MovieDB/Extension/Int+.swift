//
//  Int+.swift
//  MovieDB
//
//  Created by le.n.t.trung on 15/11/2022.
//

import Foundation

extension Int {
    func changeToDurationString() -> String {
        return "\(self / 60)h \(self % 60)m"
    }
}
