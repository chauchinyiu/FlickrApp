//
//  PhotoDetailViewController.swift
//  FlickrApp
//
//  Created by Chau Chin Yiu on 2/8/2018.
//  Copyright © 2018 Chau Chin Yiu. All rights reserved.
//

import UIKit
import LittleFramework

class PhotoDetailViewController: UIViewController,ViewModelDriven {
    
    typealias ViewModelType = PhotoDetailViewModel
    var viewModel: ViewModelType!
    
    @IBOutlet weak var photoImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel.photoName.value
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target: self, action: #selector(actionButtonPressed))
        imageBinder <~ viewModel.bigPhoto
        // Do any additional setup after loading the view.
    }
    private(set) lazy var imageBinder: Binder<UIImage?> = Binder<UIImage?> {[unowned self] (image) in
           DispatchQueue.main.async {
                self.photoImage.image = image
           }
    }
    
    @objc func actionButtonPressed(_ sender:Any?){
        print("action button")
    }
    
    

    



}
