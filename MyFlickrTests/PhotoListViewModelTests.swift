//
//  PhotoViewModelTests.swift
//  MyFlickrTests
//
//  Created by Ernest Nyumbu on 2022/01/31.
//

import XCTest
import Combine
@testable import MyFlickr

class PhotoListViewModelTests: XCTestCase {
    
    var sut: PhotoListViewModel!
    var observers: [AnyCancellable] = []
    var page: Int!
    var perPage: Int!
    var searchText: String!
    
    override func setUp() {
        super.setUp()
        sut = PhotoListViewModel(photos: [Photo]())
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
    
    func testReceivingOfDataFromServiceLayer() {
        let expectation = self.expectation(description: "fetch data.")
        PhotoListViewModel.search(page: page, perPage: perPage, text: searchText)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    DebuggingLogger.printData("Loading finished")
                case .failure(let error):
                    XCTAssertNil(error)
                }
                expectation.fulfill()
            }, receiveValue: { [weak self] value in
                XCTAssertNotNil(value)
            }).store(in: &observers)
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
}
