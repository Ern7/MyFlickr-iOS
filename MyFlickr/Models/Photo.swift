//
//  Photo.swift
//  MyFlickr
//
//  Created by Ernest Nyumbu on 2022/01/23.
//

import Foundation

 struct Photo: Codable {
     let id, owner, secret, server: String
     let farm: Int?
     let title: String
     let ispublic, isfriend, isfamily: Int?
 }
