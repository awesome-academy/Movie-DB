//
//  RequestError.swift
//  MovieDB
//
//  Created by le.n.t.trung on 07/11/2022.
//

import Foundation

enum RequestError: Error {
    case badResponse
    case badStatusCode(Int)
    case badData
}
