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
     let popularPhotos = Bindable<[Photo]>([])
     let recentPhotos = Bindable<[Photo]>([])
     let kittensPhotosCollectionCellViewModels = Bindable<[PhotoCollectionViewCellViewModel]>([])
     let dogsPhotosCollectionCellViewModels = Bindable<[PhotoCollectionViewCellViewModel]>([])
     let recentPhotosCollectionCellViewModels = Bindable<[PhotoCollectionViewCellViewModel]>([])
     let popularPhotosCollectionCellViewModels = Bindable<[PhotoCollectionViewCellViewModel]>([])
    
     let requestError  = Bindable<Error?>(nil)
     init(){
        kittenPhotosBinder <~ self.kittenPhotos
        dogsPhotosBinder <~ self.dogsPhotos
        recentPhotosBinder <~ self.recentPhotos
        popularPhotosBinder <~ self.popularPhotos
     }
   
    public func retrieveLoadedPhotoCollectionViewCellViewModels( section: Int) -> [PhotoCollectionViewCellViewModel]{
        switch(section){
        case 0:
            return kittensPhotosCollectionCellViewModels.value
        case 1:
            return dogsPhotosCollectionCellViewModels.value
        case 2:
            return popularPhotosCollectionCellViewModels.value
        case 3:
            return recentPhotosCollectionCellViewModels.value
        default:
            return []
        }
    }
    
     public func loadPhotos(){
        
        FlickrConnector.requestPhotos(method: .search(value: "cats"), onCompletion: { (error, photos) in
            if error == nil, let photos = photos, !photos.isEmpty {
                self.kittenPhotos.value = photos
            } else {
                 self.requestError.value = error
            }
        })
        
        
        FlickrConnector.requestPhotos(method: .search(value: "dogs"), onCompletion: { (error, photos) in
            if error == nil, let photos = photos, !photos.isEmpty {
                self.dogsPhotos.value = photos
            } else {
                self.requestError.value = error
            }
        })
        
        FlickrConnector.requestPhotos(method: .popular, onCompletion: { (error, photos) in
            if error == nil, let photos = photos, !photos.isEmpty {
                self.popularPhotos.value = photos
            } else {
                self.requestError.value = error
            }
        })
        
        FlickrConnector.requestPhotos(method: .recent, onCompletion: { (error, photos) in
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
    private lazy var popularPhotosBinder: Binder<[Photo]> = Binder<[Photo]> {[unowned self] (photos) in
        if !photos.isEmpty {
              print("------popular--------")
              print(photos)
             self.popularPhotosCollectionCellViewModels.value = photos.map(PhotoCollectionViewCellViewModel.init)
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
