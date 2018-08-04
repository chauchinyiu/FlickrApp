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
        @IBOutlet weak var ownerName: UILabel!
        @IBOutlet weak var dateOfTaken: UILabel!
    //    @IBOutlet weak var descriptionText: UILabel!
        @IBOutlet weak var tags: UILabel!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel.photoName.value
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
           self.ownerName.text = photoInfo?.ownerUserName
            self.dateOfTaken.text = photoInfo?.dateOfTaken
           //self.descriptionText.text = photoInfo?.description
            self.tags.text = photoInfo?.tags
        }
    }
    @objc func actionButtonPressed(_ sender:Any?){
        let alert = UIAlertController(title: "Further Actions", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Share Image", style: .default , handler:{ (UIAlertAction)in
           self.shareImage()
        }))
        
        alert.addAction(UIAlertAction(title: "Save Image to document folder", style: .default , handler:{ (UIAlertAction)in
            let success = self.saveImageInDocuments()
            if success == true {
                self.showAlert(message: "Successfully saved the image the app documents folder")
            }
            else {
                self.showAlert(message: "Cannot save the image!")
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Save Image to Photo Library", style: .default , handler:{ (UIAlertAction)in
              self.saveImageInPhotoLibrary()
        }))
        
        alert.addAction(UIAlertAction(title: "Open image in browser", style: .default , handler:{ (UIAlertAction)in
 
            self.openImageInBrowser()
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
    
    private func saveImageInPhotoLibrary(){
        UIImageWriteToSavedPhotosAlbum(self.photoImage.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            showAlert(message: "Error!")
        } else {
            showAlert(message: "Saved!")
        }
    }
      private func saveImageInDocuments() -> Bool{
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
                var name = "defaultname.png"
                if let text = self.viewModel.photoName.value {
                    name = "\(text).png"
                }
              try data.write(to: directory.appendingPathComponent(name)!)
                return true
            } catch {
                print(error.localizedDescription)
                return false
            }
        }
    
    private func openImageInBrowser(){
        guard let url = self.viewModel.bigPhotoUrl.value else {
            return
        }
        UIApplication.shared.open( url, options: [:], completionHandler: { (status) in
            
        })
    }
    
    private func showAlert(message:String) {
        let alertController = UIAlertController(title: "Flickr App", message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
}
