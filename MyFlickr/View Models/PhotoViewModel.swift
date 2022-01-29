//
//  PhotoViewModel.swift
//  MyFlickr
//
//  Created by Ernest Nyumbu on 2022/01/29.
//

import Foundation
import Combine
import ARKit

struct PhotoListViewModel {
    let photos: [Photo]
}

extension PhotoListViewModel {
    
    var numberOfSections: Int {
        return 1
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return self.photos.count
    }
    
    func photoAtIndex(_ index: Int) -> PhotoViewModel {
        let photo = self.photos[index]
        return PhotoViewModel(photo)
    }
    
    static func search(page: Int = 1, perPage: Int = 20, text: String = "") -> Future<[Photo], APICallError> {
        return Future { promixe in
            FlickrApiService.shared.load(resource: SearchResponse.search(page: page, perPage: perPage, text: text)) { [self] result in
                switch result {
                case .success(let response):
                    promixe(.success(response.photos.photo))
                case .failure(let error):
                    DebuggingLogger.printData(error)
                    promixe(.failure(error))
                }
            }
        }
    }
    
}

struct PhotoViewModel {
    private let photo: Photo
}

extension PhotoViewModel {
    init(_ photo: Photo) {
        self.photo = photo
    }
}

extension PhotoViewModel {
    
    var id: String {
        return self.photo.id
    }
    
    var owner: String {
        return self.photo.owner
    }
    
    var secret: String {
        return self.photo.secret
    }
    
    var server: String {
        return self.photo.server
    }
    
    var farm: Int {
        return self.photo.farm ?? 0
    }
    
    var title: String {
        return self.photo.title
    }
    
    var ispublic: Int {
        return self.photo.ispublic ?? 0
    }
    
    var isfriend: Int {
        return self.photo.isfriend ?? 0
    }
    
    var isfamily: Int {
        return self.photo.isfamily ?? 0
    }
}
