//
//  PhotoDetailViewModel.swift
//  FlickrApp
//
//  Created by Chau Chin Yiu on 3/8/2018.
//  Copyright © 2018 Chau Chin Yiu. All rights reserved.
//

import UIKit
import LittleFramework

final class PhotoDetailViewModel: ViewModel {
    let photoID = Bindable<String?>(nil)
    let photoName = Bindable<String?>(nil)
    let bigPhotoUrl = Bindable<URL?>(nil)
    let bigPhoto = Bindable<UIImage?>(nil)
    
    init(collectionViewCellViewModel: PhotoCollectionViewCellViewModel) {
        photoID.value = collectionViewCellViewModel.flickrPhoto.photoId
        photoName.value = collectionViewCellViewModel.flickrPhoto.title
        bigPhotoUrl.value = collectionViewCellViewModel.flickrPhoto.bigPhotoUrl
        FlickrConnector.loadImage(url: bigPhotoUrl.value!) { (error, image) in
            if image != nil {
                self.bigPhoto.value = image
            }
        }
    }
}
