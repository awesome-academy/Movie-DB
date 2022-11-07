//
//  VideoTrailer.swift
//  MovieDB
//
//  Created by le.n.t.trung on 07/11/2022.
//

import Foundation
import UIKit

struct VideoList: Codable {
    let videos: [Video]
}

struct Video: Codable {
    let key: String
    let name: String
    let site: String
    let size: Int
    let official: Bool

    private enum CodingKeys: String, CodingKey {
        case key
        case name
        case site
        case size
        case official
    }
}
