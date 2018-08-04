//
//  FlickrPhoto.swift
//  FlickrApp
//
//  Created by Chau Chin Yiu on 31/7/2018.
//  Copyright © 2018 Chau Chin Yiu. All rights reserved.
//

import UIKit
import Foundation

struct Photo {
    let photoId: String
    let farm: Int
    let secret: String
    let server: String
    let title: String
    let description: String
    var photoUrl: URL {
        return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(photoId)_\(secret)_m.jpg")!
    }
    
    var bigPhotoUrl: URL {
         return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(photoId)_\(secret)_b.jpg")!
    }
    
    init(photoDictionary: NSDictionary) {
          photoId = photoDictionary["id"] as? String ?? ""
          farm = photoDictionary["farm"] as? Int ?? 0
          secret = photoDictionary["secret"] as? String ?? ""
          server = photoDictionary["server"] as? String ?? ""
          title = photoDictionary["title"] as? String ?? ""
           if let content = photoDictionary["description"] as? NSDictionary,
              let text = content["_content"] as? String {
             description = text
           }else{
            description = ""
            }
    }
}
