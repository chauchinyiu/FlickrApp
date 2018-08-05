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
    let dateUploaded : String
    let dateOfTaken : String
    let ownerUserName : String
    let tags : String
 
    

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
        if let text = photoDictionary["title"] as? String {
             title = text
        } else if let dict = photoDictionary["title"] as? NSDictionary, let content = dict["_content"] as? String {
                title = content
        }else{
            title = ""
        }
           if let content = photoDictionary["description"] as? NSDictionary,
              let text = content["_content"] as? String {
              description = text
           }else{
              description = ""
            }
        if let millisecond  = photoDictionary["dateuploaded"] as? String,
            let timeinterval = Double(millisecond){
             let dateString = UtilitiesTool.dateFormatter().string(from: Date(timeIntervalSince1970: (timeinterval))) 
            self.dateUploaded = dateString
        }else{
            self.dateUploaded = "unknown"
        }
     
          if let owner = photoDictionary["owner"] as? NSDictionary,
             let username = owner["username"] as? String {
                ownerUserName = username
          }else {
            ownerUserName = ""
         }
        if let dates = photoDictionary["dates"] as? NSDictionary,
            let taken = dates["taken"] as? String {
            dateOfTaken = taken
        }else {
            dateOfTaken = "unknown"
        }
         if let tagsContainer  = photoDictionary["tags"] as? NSDictionary,
            let tagsArray = tagsContainer["tag"] as?  [NSDictionary] {
            var tagStrings: String = ""
            for tagDictionary in tagsArray{
                if let content = tagDictionary["_content"] as? String{
                    var space = " #"
                    if tagStrings == "" {
                        space = "#"
                    }
                    tagStrings = tagStrings.appending(space).appending(content)
                }
                
            }
            tags = tagStrings
        }else {
            tags = ""
        }
    }
}
