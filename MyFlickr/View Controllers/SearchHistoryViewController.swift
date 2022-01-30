//
//  SearchHistoryViewController.swift
//  MyFlickr
//
//  Created by Ernest Nyumbu on 2022/01/29.
//

import Foundation
import UIKit
import Combine

class SearchHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    //UI
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //DATA
    var searchBarText = ""
    
    //View Model
    private var searchHistoryItemListVM: SearchHistoryItemListViewModel!
    
    //OBSERVERS
    var observers: [AnyCancellable] = []
    
    // Segues
    let goToSearchResults = "goToSearchResults"
    let goToSearchResultsViaKeyboard = "goToSearchResultsViaKeyboard"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = ColorUtils.hexStringToUIColor(hex: Constants.AppPalette.pageBackgroundGrey)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async { [unowned self] in
                self.searchBar.becomeFirstResponder()
        }
        
        fetch()

    }
    
    private func fetch(){
        SearchHistoryItemListViewModel.fetch()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    DebuggingLogger.printData("Search items fetch finished")
                case .failure(let error):
                    DebuggingLogger.printData("Search items fetch results error: \(error.message)")
                }
            }, receiveValue: { [weak self] value in
                DebuggingLogger.printData("Search items fetch: \(value)")
                self?.searchHistoryItemListVM = SearchHistoryItemListViewModel(searchHistoryItems: value)
                self?.tableView.reloadData()
            }).store(in: &observers)
    }
    
    // MARK: - TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.searchHistoryItemListVM == nil ? 0 : self.searchHistoryItemListVM.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchHistoryItemListVM.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchHistoryItemTableViewCell", for: indexPath) as? SearchHistoryItemTableViewCell else {
            fatalError("SearchHistoryItemTableViewCell not found")
        }
        
        let searchHistoryItemVM = self.searchHistoryItemListVM.searchHistoryItemAtIndex(indexPath.row)
        cell.nameLabel.text = searchHistoryItemVM.text
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    // MARK: - SearchBar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBarText = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        var items = searchHistoryItemListVM.searchHistoryItems
        let newItem = SearchHistoryItem(text: searchBar.text!)
        items.append(newItem)
        SearchHistoryItemListViewModel.saveHistoryItems(searchHistoryItems: items)
        view.endEditing(true)
        performSegue(withIdentifier: goToSearchResultsViaKeyboard, sender: self)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == goToSearchResults,
            let destination = segue.destination as? HomeViewController,
            let selectedIndex = tableView.indexPathForSelectedRow?.row
        {
            let selectedHistoryItem = searchHistoryItemListVM.searchHistoryItems[selectedIndex]
            destination.searchText = selectedHistoryItem.text
            destination.isSearchResultsMode = true
        }
        else if segue.identifier == goToSearchResultsViaKeyboard,
                let destination = segue.destination as? HomeViewController
            {
                destination.searchText = searchBarText
                destination.isSearchResultsMode = true
            }
    }
}
