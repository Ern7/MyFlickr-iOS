//
//  Photos.swift
//  MyFlickr
//
//  Created by Ernest Nyumbu on 2022/01/29.
//

import Foundation

struct Photos: Codable {
    let page, pages, perpage, total: Int
    let photo: [Photo]
}
