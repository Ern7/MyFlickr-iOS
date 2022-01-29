//
//  SearchResponse.swift
//  MyFlickr
//
//  Created by Ernest Nyumbu on 2022/01/29.
//

import Foundation

struct SearchResponse: Codable {
    let photos: Photos
    let stat: String
}

extension SearchResponse {
    
    static func search(page: Int = 1, perPage: Int = 20, text: String = "") -> WebResource<SearchResponse> {
        
        guard let url = URL(string: "\(Constants.AppConfig.BackendUrl)services/rest/?method=flickr.photos.search&api_key=\(Constants.ApiKeys.FlickrApiKey)&format=json&media=photos&nojsoncallback=1&per_page=\(perPage)&page=\(page)&text=\(text)") else {
            fatalError("URL is incorrect!")
        }
        
        return WebResource<SearchResponse>(url: url)
    }
}
