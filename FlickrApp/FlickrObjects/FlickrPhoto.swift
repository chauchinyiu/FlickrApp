//
//  FlickrPhoto.swift
//  FlickrApp
//
//  Created by Chau Chin Yiu on 31/7/2018.
//  Copyright © 2018 Chau Chin Yiu. All rights reserved.
//

import UIKit
import Foundation

struct FlickrPhoto {
    let photoId: String
    let farm: Int
    let secret: String
    let server: String
    let title: String
    
    var photoUrl: URL {
        return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(photoId)_\(secret)_m.jpg")!
    }
    
    var bigPhotoUrl: URL {
         return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(photoId)_\(secret)_b.jpg")!
    }
}
