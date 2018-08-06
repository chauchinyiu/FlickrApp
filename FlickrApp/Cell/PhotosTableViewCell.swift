//
//  PhotosTableViewCell.swift
//  FlickrApp
//
//  Created by Chau Chin Yiu on 31/7/2018.
//  Copyright © 2018 Chau Chin Yiu. All rights reserved.
//

import UIKit
import LittleFramework

class PhotosTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    var collectionViewCellViewModels : [PhotoCollectionViewCellViewModel] = []
}

extension PhotosTableViewCell {
 
    func updateCollectionViewContent(viewModels: [PhotoCollectionViewCellViewModel]){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionViewCellViewModels = viewModels
        collectionView.reloadData()
    }
}

extension PhotosTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return collectionViewCellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : PhotoCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
 
        let cellViewModel: PhotoCollectionViewCellViewModel = collectionViewCellViewModels[indexPath.item]
        cell.bind(to:cellViewModel)
        return cell
    }
    
}
