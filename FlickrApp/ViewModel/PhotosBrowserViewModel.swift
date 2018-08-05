//
//  PhotosBrowserViewModel.swift
//  FlickrApp
//
//  Created by Chau Chin Yiu on 2/8/2018.
//  Copyright © 2018 Chau Chin Yiu. All rights reserved.
//

import UIKit
import LittleFramework

final class PhotosBrowserViewModel: ViewModel {
    
     let kittenPhotos = Bindable<[Photo]>([])
     let dogsPhotos = Bindable<[Photo]>([])
     let interestingPhotos = Bindable<[Photo]>([])
     let recentPhotos = Bindable<[Photo]>([])
     let kittensPhotosCollectionCellViewModels = Bindable<[PhotoCollectionViewCellViewModel]>([])
     let dogsPhotosCollectionCellViewModels = Bindable<[PhotoCollectionViewCellViewModel]>([])
     let recentPhotosCollectionCellViewModels = Bindable<[PhotoCollectionViewCellViewModel]>([])
     let interestingPhotosCollectionCellViewModels = Bindable<[PhotoCollectionViewCellViewModel]>([])
    
     let requestError  = Bindable<Error?>(nil)
     init(){
        kittenPhotosBinder <~ self.kittenPhotos
        dogsPhotosBinder <~ self.dogsPhotos
        recentPhotosBinder <~ self.recentPhotos
        interestingPhotosBinder <~ self.interestingPhotos
     }
   
    public func retrieveLoadedPhotoCollectionViewCellViewModels( section: Int) -> [PhotoCollectionViewCellViewModel]{
        switch(section){
        case 0:
            return kittensPhotosCollectionCellViewModels.value
        case 1:
            return dogsPhotosCollectionCellViewModels.value
        case 2:
            return interestingPhotosCollectionCellViewModels.value
        case 3:
            return recentPhotosCollectionCellViewModels.value
        default:
            return []
        }
    }
    
    public func loadPhotos(_ isPostDescending: Bool = true){
        
        FlickrConnector.requestPhotos(method: .search(value: "cats"), isPostDescending, onCompletion: { (error, photos) in
            if error == nil, let photos = photos, !photos.isEmpty {
                self.kittenPhotos.value = photos
            } else {
                 self.requestError.value = error
            }
        })
        
        
        FlickrConnector.requestPhotos(method: .search(value: "dogs"), isPostDescending, onCompletion: { (error, photos) in
            if error == nil, let photos = photos, !photos.isEmpty {
                self.dogsPhotos.value = photos
            } else {
                self.requestError.value = error
            }
        })
        
        FlickrConnector.requestPhotos(method: .interesting, isPostDescending, onCompletion: { (error, photos) in
            if error == nil, let photos = photos, !photos.isEmpty {
                self.interestingPhotos.value = photos
            } else {
                self.requestError.value = error
            }
        })
        
        FlickrConnector.requestPhotos(method: .recent, isPostDescending, onCompletion: { (error, photos) in
            if error == nil, let photos = photos, !photos.isEmpty {
                self.recentPhotos.value = photos
            } else {
                self.requestError.value = error
            }
        })
    }
    private lazy var kittenPhotosBinder: Binder<[Photo]> = Binder<[Photo]> {[unowned self] (photos) in
        if !photos.isEmpty {
            print("------cat--------")
                       print(photos)
            self.kittensPhotosCollectionCellViewModels.value = photos.map(PhotoCollectionViewCellViewModel.init)
        }
    }
    
    private lazy var dogsPhotosBinder: Binder<[Photo]> = Binder<[Photo]> {[unowned self] (photos) in
        if !photos.isEmpty {
            print("------dog--------")
                       print(photos)
            self.dogsPhotosCollectionCellViewModels.value = photos.map(PhotoCollectionViewCellViewModel.init)
        }
    }
    private lazy var interestingPhotosBinder: Binder<[Photo]> = Binder<[Photo]> {[unowned self] (photos) in
        if !photos.isEmpty {
              print("------interesting--------")
              print(photos)
             self.interestingPhotosCollectionCellViewModels.value = photos.map(PhotoCollectionViewCellViewModel.init)
            }
        }
    
    
    private lazy var recentPhotosBinder: Binder<[Photo]> = Binder<[Photo]> {[unowned self] (photos) in
         if !photos.isEmpty {
            print("------recent--------")
                       print(photos)
             self.recentPhotosCollectionCellViewModels.value = photos.map(PhotoCollectionViewCellViewModel.init)
        }
    }


}
