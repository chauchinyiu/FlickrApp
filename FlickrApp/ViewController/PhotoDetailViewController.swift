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
        @IBOutlet weak var titleText: UILabel!
        @IBOutlet weak var ownerName: UILabel!
        @IBOutlet weak var dateOfTaken: UILabel!
        @IBOutlet weak var dateUploaded : UILabel!
        @IBOutlet weak var tags: UILabel!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel.photoName.value
        self.titleText.text = "Title: \(viewModel.photoName.value ?? "")"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target: self, action: #selector(actionButtonPressed))
        imageBinder <~ viewModel.bigPhoto
        photoInfoBinder <~ viewModel.photoDetail
        // Do any additional setup after loading the view.
    }
    private(set) lazy var imageBinder: Binder<UIImage?> = Binder<UIImage?> {[unowned self] (image) in
        DispatchQueue.main.async {
            self.photoImage.image = image
        }
    }
    private(set) lazy var photoInfoBinder: Binder<Photo?> = Binder<Photo?> {[unowned self] (photoInfo) in
        DispatchQueue.main.async {
            self.ownerName.text? = "Owner: \(photoInfo?.ownerUserName ?? "")"
            self.dateOfTaken.text = "Date Taken: \(photoInfo?.dateOfTaken ?? "")"
            self.dateUploaded.text = "Date Uploaded: \(photoInfo?.dateUploaded ?? "")" 
            self.tags.text = "Tags: \(photoInfo?.tags ?? "")"
        }
    }
    @objc func actionButtonPressed(_ sender:Any?){
        let alert = UIAlertController(title: "Further Actions", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Share Image", style: .default , handler:{ (UIAlertAction)in
            guard let image = self.photoImage.image else {
                return
            }
            UtilitiesTool.share(image: image, in: self)
        }))
        
        alert.addAction(UIAlertAction(title: "Save Image to document folder", style: .default , handler:{ (UIAlertAction)in
            guard let image = self.photoImage.image, let name = self.viewModel.photoName.value else {
                return
            }
           UtilitiesTool.saveImageInDocuments(image: image, name: name, in: self)
    
        }))
        
        alert.addAction(UIAlertAction(title: "Save Image to Photo Library", style: .default , handler:{ (UIAlertAction)in
            guard let image = self.photoImage.image else {
                return
            }
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Open image in browser", style: .default , handler:{ (UIAlertAction)in
            guard let url = self.viewModel.bigPhotoUrl.value else {
                return
            }
            UtilitiesTool.openImageInBrowser(imageURL: url)
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            
        }))
        
        self.present(alert, animated: true, completion: {
        
        })
    }
    
    
 
    
 
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            UtilitiesTool.showAlert(message: "Failed to save in photo library", in: self)
        } else {
            UtilitiesTool.showAlert(message: "Successfully saved!!!", in: self)
        }
    }
    
 
}
