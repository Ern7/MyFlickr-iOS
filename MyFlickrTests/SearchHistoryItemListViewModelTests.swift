//
//  SearchHistoryItemListViewModelTests.swift
//  MyFlickrTests
//
//  Created by Ernest Nyumbu on 2022/01/31.
//

import XCTest
import Combine
@testable import MyFlickr

class SearchHistoryItemListViewModelTests: XCTestCase {
    
    var sut: SearchHistoryItemListViewModel!
    var observers: [AnyCancellable] = []
    var searchText: String!
    
    override func setUp() {
        super.setUp()
        sut = SearchHistoryItemListViewModel(searchHistoryItems: [SearchHistoryItem]())
        searchText = "Paris"
    }
    
    override func tearDown() {
        sut = nil
        searchText = nil
        super.tearDown()
    }
    
    func testFetch() {
        let expectation = self.expectation(description: "fetch history items.")
        SearchHistoryItemListViewModel.fetch()
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
    
    func testSavingOfHistoryItem(){
        let expectation = self.expectation(description: "fetch history items.")
        
        //save item
        var items = sut.searchHistoryItems
        let newItem = SearchHistoryItem(text: searchText)
        items.append(newItem)
        SearchHistoryItemListViewModel.saveHistoryItems(searchHistoryItems: items)
        
        //fetch items to see if newly saved item is in the list
        SearchHistoryItemListViewModel.fetch()
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
                
                XCTAssertEqual(value[0].text, self?.searchText)
            }).store(in: &observers)
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
}
