//
//  HomeViewController.swift
//  MyFlickr
//
//  Created by Ernest Nyumbu on 2022/01/29.
//

import Foundation
import UIKit
import Combine
import Kingfisher
import Lottie

class HomeViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //UI
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorDescriptionLabel: UILabel!
    @IBOutlet weak var errorRefreshButton: UIButton!
    @IBOutlet weak var errorAnimationView: AnimationView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    //collectionView configs
    let inset: CGFloat = 10
    let minimumLineSpacing: CGFloat = 10
    let minimumInteritemSpacing: CGFloat = 10
    let cellsPerRow = 2

    //ViewModel
    private var photoListVM = PhotoListViewModel(photos: [Photo]())
  //  private var photoListVM: PhotoListViewModel!
    
    //DATA
    var currentPage = 1
    var pageSize = 20
    var searchText = ""
    
    //OBSERVERS
    var observers: [AnyCancellable] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Navigation Controller
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name:Constants.Font.bold, size:18)!]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont(name:Constants.Font.bold, size:30)!]
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let columnLayout = ColumnFlowLayout(
                cellsPerRow: 2,
                minimumInteritemSpacing: 10,
                minimumLineSpacing: 10,
                sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10),
                headerReferenceSize: CGSize(width: 0, height: 1)
            )
        
        collectionView?.collectionViewLayout = columnLayout
        collectionView?.contentInsetAdjustmentBehavior = .always
        
        errorAnimationView.contentMode = .scaleAspectFit
        errorAnimationView.loopMode = .loop
        errorAnimationView.animationSpeed = 0.5
        hideErrorView()
        
        search()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ColorUtils.hexStringToUIColor(hex: Constants.AppPalette.primaryColor)]
    }
    
    private func search(){
        showLoader()
        PhotoListViewModel.search(page: currentPage, perPage: pageSize, text: searchText)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    DebuggingLogger.printData("search finished")
                case .failure(let error):
                    DebuggingLogger.printData("Search results error: \(error.message)")
                    self.showErrorView(message: error.message)
                }
            }, receiveValue: { [weak self] value in
                DebuggingLogger.printData("Search results: \(value)")
                self?.hideLoader()
                self?.photoListVM = PhotoListViewModel(photos: value)
                self?.collectionView.isHidden = false
                self?.collectionView.reloadData()
            }).store(in: &observers)
    }
    
    // MARK: - Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photoListVM.numberOfRowsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell else {
            fatalError("HomeCollectionViewCell not found")
        }
        
        let photoTypeVM = self.photoListVM.photoAtIndex(indexPath.row)
        let url = URL(string: photoTypeVM.photoUrl)
        cell.photoImageView.kf.setImage(with: url)
        
        if photoTypeVM.title.isEmpty {
            cell.titleParentView.isHidden = true
        }
        else {
            cell.titleLabel.text = photoTypeVM.title
            cell.titleParentView.isHidden = false
        }
        return cell
    }
    
    //MARK: - Error View
    @IBAction func refreshData(_ sender: Any) {
        search()
    }
    
    private func showErrorView(message: String) {
        DispatchQueue.main.async {
            self.collectionView.isHidden = true
            self.errorDescriptionLabel.text = message
            self.errorView.isHidden = false
            self.errorAnimationView.play()
            self.hideLoader()
        }
    }
    
    private func hideErrorView() {
        DispatchQueue.main.async {
            self.errorView.isHidden = true
            self.errorAnimationView.stop()
        }
    }
    
    //MARK: - Activity Indicator methods
    private func showLoader() {
        DispatchQueue.main.async {
            self.errorView.isHidden = true
            self.activityIndicatorView.isHidden = false
            self.activityIndicatorView.startAnimating()
        }
    }
    
    private func hideLoader() {
        DispatchQueue.main.async {
            self.activityIndicatorView.isHidden = true
            self.activityIndicatorView.stopAnimating()
        }
    }
}
