//
//  PhotoTest.swift
//  FlickrAppTests
//
//  Created by Chau Chin Yiu on 06.08.18.
//  Copyright © 2018 Chau Chin Yiu. All rights reserved.
//

import XCTest

class PhotoTest: BaseUnitTests {
    static let photoDictionary : String =  "{ \"id\": \"43162524074\", \"owner\": \"138407006@N02\", \"secret\": \"8ccb9041bd\", \"server\": \"1792\", \"farm\": 2, \"title\": \"With this wonderful man\", \"ispublic\": 1, \"isfriend\": 0, \"isfamily\": 0  }"
    
    static let photoInfoDictionary : String = "{\"id\": \"43162524074\",\"secret\":\"8ccb9041bd\",\"server\": \"1792\",\"farm\": 2,\"dateuploaded\": \"1533546913\",\"isfavorite\": 0,\"license\": 0,\"safety_level\": 0, \"rotation\": 0, \"originalsecret\": \"ff6fc3329d\",\"originalformat\": \"jpg\",\"owner\": { \"nsid\": \"138407006@N02\", \"username\": \"Mohammad Sadegh Eslami Manouchehri Photo Archiv\", \"realname\": \"Mohammad Sadegh Eslami Manouchehri\",\"location\": \"\",\"iconserver\": \"4562\",\"iconfarm\": 5,\"path_alias\": \"msemphotoarchive\"},\"title\": {\"_content\": \"With this wonderful man\"},\"description\": {\"_content\": \"\"},\"visibility\": {\"ispublic\": 1,\"isfriend\": 0,\"isfamily\": 0},\"dates\": {\"posted\": \"1533546913\",\"taken\": \"2018-07-28 20:29:33\",\"takengranularity\": 0,\"takenunknown\": 0,\"lastupdate\": \"1533546913\"},\"views\": 9,\"editability\": {\"cancomment\": 0,\"canaddmeta\": 0},\"publiceditability\": {\"cancomment\": 1,\"canaddmeta\": 1},\"usage\": {\"candownload\": 1,\"canblog\": 0,\"canprint\": 0,\"canshare\": 1},\"comments\": {\"_content\": 0},\"notes\": {\"note\": []},\"people\": {\"haspeople\": 1},\"tags\": {\"tag\": [{\"id\": \"138386658-43162524074-1344\",\"author\": \"138407006@N02\",\"authorname\": \"Mohammad Sadegh Eslami Manouchehri Photo Archiv\",\"raw\": \"cat\",\"_content\": \"cat\",\"machine_tag\": \"\"},{    \"id\": \"138386658-43162524074-364\",    \"author\": \"138407006@N02\",    \"authorname\": \"Mohammad Sadegh Eslami Manouchehri Photo Archiv\", \"raw\": \"cats\",\"_content\": \"cats\",\"machine_tag\": \"\"}]},\"urls\": {\"url\": [{\"type\": \"photopage\",\"_content\": \"\"}]},\"media\": \"photo\"}"
  
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPhotoInit() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let dict = convertToDictionary(text: PhotoTest.photoDictionary)
        let photo = Photo(photoDictionary: dict! as NSDictionary)
        XCTAssertTrue(photo.photoUrl.absoluteString ==  "https://farm2.staticflickr.com/1792/43162524074_8ccb9041bd_m.jpg")
        XCTAssertTrue(photo.bigPhotoUrl.absoluteString == "https://farm2.staticflickr.com/1792/43162524074_8ccb9041bd_b.jpg")
    }
    
    func testPhotoInfoInit() {
        // This is an example of a performance test case.
        let dict = convertToDictionary(text: PhotoTest.photoInfoDictionary)
        let photo = Photo(photoDictionary: dict! as NSDictionary)
        XCTAssertTrue(photo.photoUrl.absoluteString ==  "https://farm2.staticflickr.com/1792/43162524074_8ccb9041bd_m.jpg")
        XCTAssertTrue(photo.bigPhotoUrl.absoluteString == "https://farm2.staticflickr.com/1792/43162524074_8ccb9041bd_b.jpg")
        XCTAssertTrue(photo.tags == "#cat #cats")
        XCTAssertTrue(photo.dateOfTaken == "2018-07-28 20:29:33")
        XCTAssertTrue(photo.dateUploaded == "2018-08-06 11:15:13")
        XCTAssertTrue(photo.title == "With this wonderful man")
        XCTAssertTrue(photo.ownerUserName == "Mohammad Sadegh Eslami Manouchehri Photo Archiv")
    }
    
}
