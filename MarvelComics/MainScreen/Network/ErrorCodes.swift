//
//  ErrorCodes.swift
//  MarvelComics
//
//  Created by Михаил Лоюк on 21.11.2021.
//

import Foundation

struct ErrorCode401: Decodable {
    let code: String?
    let message: String?
}

struct ErrorCode409: Decodable {
    let code: Int?
    let status: String?
}
