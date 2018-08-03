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
        let alert = UIAlertController(title: "Further Actions", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Share Image", style: .default , handler:{ (UIAlertAction)in
           self.shareImage()
        }))
        
        alert.addAction(UIAlertAction(title: "Save Image to document folder", style: .default , handler:{ (UIAlertAction)in
           self.saveImage()
        }))
        
        alert.addAction(UIAlertAction(title: "Open image in browser", style: .default , handler:{ (UIAlertAction)in
            print("User click Delete button")
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    
    
    private func shareImage(){
        // image to share
        let image = self.photoImage.image
        
        // set up activity view controller
        let imageToShare = [image]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
 
      private  func saveImage() -> Bool{
            guard let image = self.photoImage.image else {
                return false
            }
            guard let data = UIImageJPEGRepresentation(image, 1) ?? UIImagePNGRepresentation(image) else {
                return false
            }
            guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
                return false
            }
            do {
                try data.write(to: directory.appendingPathComponent( "\(String(describing: viewModel.photoName.value)).png")!)
                return true
            } catch {
                print(error.localizedDescription)
                return false
            }
        }
    
    
    
}
