//
//  UtilitiesTool.swift
//  FlickrApp
//
//  Created by Chau Chin Yiu on 5/8/2018.
//  Copyright © 2018 Chau Chin Yiu. All rights reserved.
//

import UIKit

class UtilitiesTool  {
    
    
    static func share(image: UIImage,  in viewController: UIViewController){
        let imageToShare = [image]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = viewController.view
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        viewController.present(activityViewController, animated: true, completion: nil)
    }
    
    static func saveImageInDocuments(image: UIImage, name: String = "default", in viewController: UIViewController)   {
     
        guard let data = UIImageJPEGRepresentation(image, 1) ?? UIImagePNGRepresentation(image) else {
            showAlert(message: "Failed to save in Documents!", in: viewController)
            return
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            showAlert(message: "Failed to save in Documents!", in: viewController)
            return
        }
        do {
            
            let fileName = "\(name).png"
            try data.write(to: directory.appendingPathComponent(fileName)!)
            showAlert(message: "Successfully saved", in: viewController)
        } catch {
            print(error.localizedDescription)
            showAlert(message: "Failed to save in Documents!", in: viewController)
        }
    }
    
     static func openImageInBrowser(imageURL: URL){
 
        UIApplication.shared.open( imageURL, options: [:], completionHandler: { (status) in
            
        })
    }
    
    static func showAlert(message:String, in viewController: UIViewController) {
        let alertController = UIAlertController(title: "Flickr App", message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        viewController.present(alertController, animated: true, completion: nil)
    }

    static func dateFormatter() -> DateFormatter{
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
      return formatter
    }

}
