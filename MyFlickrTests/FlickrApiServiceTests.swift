//
//  FlickrApiServiceTests.swift
//  MyFlickrTests
//
//  Created by Ernest Nyumbu on 2022/01/31.
//

import XCTest
@testable import MyFlickr

class FlickrApiServiceTests: XCTestCase {
    
    var sut: FlickrApiService!
    var page: Int!
    var perPage: Int!
    var searchText: String!
    
    override func setUp() {
        super.setUp()
        sut = FlickrApiService.shared
        page = 1
        perPage = 10
        searchText = ""
    }
    
    override func tearDown() {
        sut = nil
        page = nil
        perPage = nil
        searchText = nil
        super.tearDown()
    }
    
    func testLoadInitialData() {
        
        let expectation = self.expectation(description: "fetch initial data.")
        
        sut.load(resource: SearchResponse.search(page: page, perPage: perPage, text: searchText)) {result in
            switch result {
            case .success(let response):
                XCTAssertNotNil(response)
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 6.0, handler: nil)
        
    }
    
    func testLoadMoreData() {
        
        let expectation = self.expectation(description: "fetch more data.")
        page = page + 1
        sut.load(resource: SearchResponse.search(page: page, perPage: perPage, text: searchText)) {result in
            switch result {
            case .success(let response):
                XCTAssertNotNil(response)
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 6.0, handler: nil)
        
    }
    
    func testErrorHandlingWhenFetchingData() {
        
        
        let expectation = self.expectation(description: "fetch weather forecast failed.")
        
        sut.load(resource: searchWithIncorrectUrl(page: page, perPage: perPage, text: searchText)) { result in
            switch result {
            case .success(let response):
                XCTAssertNotNil(response)   //will not hit. Do i need this here???
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 6.0, handler: nil)
        
    }
    
    func searchWithIncorrectUrl(page: Int = 1, perPage: Int = 20, text: String = "") -> WebResource<SearchResponse> {
        
        guard let url = URL(string: "\(Constants.AppConfig.BackendUrl)servicesSSSS/rest/?method=flickr.photos.search&api_key=\(Constants.ApiKeys.FlickrApiKey)&format=json&media=photos&nojsoncallback=1&per_page=\(perPage)&page=\(page)&text=\(text)") else {
            fatalError("URL is incorrect!")
        }
        
        return WebResource<SearchResponse>(url: url)
    }
}
