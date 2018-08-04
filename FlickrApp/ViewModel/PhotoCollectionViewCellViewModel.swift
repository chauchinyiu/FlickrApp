//
//  ImageCellViewModel.swift
//  FlickrApp
//
//  Created by Chau Chin Yiu on 2/8/2018.
//  Copyright © 2018 Chau Chin Yiu. All rights reserved.
//

import UIKit
import LittleFramework

class PhotoCollectionViewCellViewModel: ViewModel {
    let photoID = Bindable<String?>(nil)
    let photoName = Bindable<String?>(nil)
    let photoImageUrl = Bindable<URL?>(nil)
    let photoImage = Bindable<UIImage?>(nil)
    
    let flickrPhoto: Photo
    init(photo: Photo) {
        flickrPhoto = photo
        photoID.value = photo.photoId
        photoName.value = photo.title
        photoImageUrl.value = photo.photoUrl
        FlickrConnector.loadImage(url: photo.photoUrl) { (error, image) in
            if image != nil{
                self.photoImage.value = image
            }
        }
    }
}
