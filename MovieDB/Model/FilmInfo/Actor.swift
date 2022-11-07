//
//  Actor.swift
//  MovieDB
//
//  Created by le.n.t.trung on 07/11/2022.
//

import Foundation
import UIKit

struct ActorList: Codable {
    let actors: [Actor]
}

struct Actor: Codable {
    let id: Int
    let name: String
    let profileImageURL: String
    let castId: String
    let character: String
    let gender: Int

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case profileImageURL
        case castId
        case character
        case gender
    }
}
