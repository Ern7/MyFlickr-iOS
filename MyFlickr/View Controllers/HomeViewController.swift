//
//  HomeViewController.swift
//  MyFlickr
//
//  Created by Ernest Nyumbu on 2022/01/29.
//

import Foundation
import UIKit
import Combine

class HomeViewController : UIViewController {
    
    //DATA
    var currentPage = 1
    var searchText = ""
    
    //OBSERVERS
    var observers: [AnyCancellable] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        search()
    }
    
    private func search(){
        PhotoListViewModel.search(page: currentPage, perPage: 10, text: searchText)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    DebuggingLogger.printData("search finished")
                case .failure(let error):
                    DebuggingLogger.printData("Search results error: \(error.message)")
                   // self.removeLoadingOverlay()
                    let alert = UIAlertController(title: "Error", message: error.message, preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { action in
                        self.search()
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
                        _ = self.navigationController?.popViewController(animated: true)
                    }))

                    self.present(alert, animated: true)
                }
            }, receiveValue: { [weak self] value in
                //self?.adaptPlaces(places: value)
                DebuggingLogger.printData("Search results: \(value)")
            }).store(in: &observers)
    }
    
}
