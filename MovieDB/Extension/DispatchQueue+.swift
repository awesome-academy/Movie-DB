//
//  DispatchQueue+.swift
//  MovieDB
//
//  Created by le.n.t.trung on 22/11/2022.
//

import Foundation

extension DispatchQueue {
    static func background(delay: Double = 0.0, background: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
}
