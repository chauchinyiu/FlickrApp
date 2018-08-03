//
//  Section.swift
//  FlickrApp
//
//  Created by Chau Chin Yiu on 3/8/2018.
//  Copyright © 2018 Chau Chin Yiu. All rights reserved.
//

import Foundation

enum Section : Int{
    case cats = 0
    case dogs = 1
    case popular = 2
    case recent = 3
    
    var sectionTitle: String {
        switch (self){
        case .cats:
            return "Cat"
        case .dogs:
            return "Dogs"
        case .popular:
            return "Popular"
        case .recent:
            return "Recent"
        }
    }
    static let numberOfSections = 4
    
    var sectionIndexPath: IndexPath {
        switch (self){
        case .cats:
            return IndexPath(row: 0, section: 0)
        case .dogs:
            return IndexPath(row: 0, section: 1)
        case .popular:
            return IndexPath(row: 0, section: 2)
        case .recent:
            return IndexPath(row: 0, section: 3)
        }
    }
}

