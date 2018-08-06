//
//  PhotoCollectionViewCell.swift
//  FlickrApp
//
//  Created by Chau Chin Yiu on 2/8/2018.
//  Copyright © 2018 Chau Chin Yiu. All rights reserved.
//
import LittleFramework
import UIKit

class PhotoCollectionViewCell: UICollectionViewCell, ViewModelBinder {
    @IBOutlet weak var photoName: UILabel!
    @IBOutlet weak var photoImage: UIImageView!
    typealias ViewModelBinderType = PhotoCollectionViewCellViewModel
    var cellViewModel:PhotoCollectionViewCellViewModel?
    func bind(to viewModel: PhotoCollectionViewCellViewModel) {
        cellViewModel = viewModel
        photoName.text = viewModel.photoName.value
        imageBinder <~ viewModel.photoImage
    }

    private(set) lazy var imageBinder: Binder<UIImage?> = Binder<UIImage?> {[unowned self] (image) in
        DispatchQueue.main.async {
            self.photoImage.image = image
        }
    }
   
}
