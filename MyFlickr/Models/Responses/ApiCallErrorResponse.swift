//
//  ApiCallErrorResponse.swift
//  MyFlickr
//
//  Created by Ernest Nyumbu on 2022/01/23.
//

import Foundation

struct ApiCallErrorResponse : Codable {
    let stat: String
    let code: Int
    let message: String
}
