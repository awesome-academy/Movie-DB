//
//  DelayerRunner.swift
//  MovieDB
//
//  Created by le.n.t.trung on 14/11/2022.
//

import Foundation

final class DelayedRunner {
    private var seconds: Double = 500
    private var timer: Timer?

    static func initWithDuration(seconds: Double) -> DelayedRunner {
        let obj = DelayedRunner()
        obj.seconds = seconds
        return obj
    }
    
    func run(action: @escaping (() -> Void)) {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        timer = Timer .scheduledTimer(withTimeInterval: seconds, repeats: false, block: { _ in
            action()
        })
    }
}
