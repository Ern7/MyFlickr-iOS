//
//  SearchHistoryItemViewModel.swift
//  MyFlickr
//
//  Created by Ernest Nyumbu on 2022/01/29.
//

import Foundation
import Combine
import ARKit

struct SearchHistoryItemListViewModel {
    let searchHistoryItems: [SearchHistoryItem]
}

extension SearchHistoryItemListViewModel {
    
    var numberOfSections: Int {
        return 1
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return self.searchHistoryItems.count
    }
    
    func searchHistoryItemAtIndex(_ index: Int) -> SearchHistoryItemViewModel {
        let searchHistoryItem = self.searchHistoryItems[index]
        return SearchHistoryItemViewModel(searchHistoryItem)
    }
    
    static func fetch() -> Future<[SearchHistoryItem], APICallError> {
        return Future { promixe in
            let userDefaults = UserDefaults.standard
            if userDefaults.string(forKey: Constants.UserDefaultsKeys.SearchHistoryItems) == nil {
                userDefaults.set("", forKey: Constants.UserDefaultsKeys.SearchHistoryItems)
            }
            
            let itemsString = userDefaults.string(forKey: Constants.UserDefaultsKeys.SearchHistoryItems)
            let items = convert(stringArray: itemsString!)
            promixe(.success(items))
        }
    }
    
    static func saveHistoryItems(searchHistoryItems: [SearchHistoryItem]) {
        let stringArray = convert(searchHistoryItems: searchHistoryItems)
        let userDefaults = UserDefaults.standard
        userDefaults.set(stringArray, forKey: Constants.UserDefaultsKeys.SearchHistoryItems)
    }
    
    private static func convert(stringArray: String) -> [SearchHistoryItem] {
        var searchHistoryItems = [SearchHistoryItem]()
        if !stringArray.isEmpty {
            let array = stringArray.components(separatedBy: ",")
            for item in array {
                if !item.isEmpty {
                    searchHistoryItems.append(SearchHistoryItem(text: item))
                    
                }
            }
        }
        return searchHistoryItems
    }
    
    private static func convert(searchHistoryItems: [SearchHistoryItem]) -> String {
        var searchHistoryString = ""
        if !searchHistoryItems.isEmpty {
            for historyItem in searchHistoryItems {
                if !historyItem.text.isEmpty{
                    if searchHistoryItems.isEmpty {
                        searchHistoryString = historyItem.text
                    }
                    else {
                        searchHistoryString = "\(searchHistoryString),\(historyItem.text)"
                    }
                }
            }
        }
        return searchHistoryString
    }
    
}

struct SearchHistoryItemViewModel {
    private let searchHistoryItem: SearchHistoryItem
}

extension SearchHistoryItemViewModel {
    init(_ searchHistoryItem: SearchHistoryItem) {
        self.searchHistoryItem = searchHistoryItem
    }
}

extension SearchHistoryItemViewModel {
    
    var text: String {
        return self.searchHistoryItem.text
    }
}

  
