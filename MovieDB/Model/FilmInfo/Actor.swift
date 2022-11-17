//
//  Actor.swift
//  MovieDB
//
//  Created by le.n.t.trung on 07/11/2022.
//

import Foundation
import UIKit

struct ActorList: Codable {
    let cast: [Actor]
}

struct Actor: Codable {
    let id: Int
    let name: String
    let profileImageURL: String?
    let castId: Int
    let character: String
    let gender: Int

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case profileImageURL = "profile_path"
        case castId = "cast_id"
        case character
        case gender
    }
}
