//
//  PhotoDetailViewController.swift
//  MyFlickr
//
//  Created by Ernest Nyumbu on 2022/01/30.
//

import Foundation
import UIKit
import Kingfisher

class PhotoDetailViewController : UIViewController {
    
    //UI VIEWS
    @IBOutlet weak var photoImageView: UIImageView!
    
    //VIEWMODEL
    public var photoVM: PhotoViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = photoVM.title.isEmpty ? "Photo" : photoVM.title
        navigationItem.largeTitleDisplayMode = .never
        
        let url = URL(string: photoVM.photoUrl)
        photoImageView.kf.setImage(with: url)
    }
    
}
