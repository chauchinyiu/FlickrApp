//
//  FlickrConnector.swift
//  FlickrApp
//
//  Created by Chau Chin Yiu on 31/7/2018.
//  Copyright © 2018 Chau Chin Yiu. All rights reserved.
//

import UIKit


fileprivate let imageCache = NSCache<NSString, UIImage>()

class FlickrConnector: NSObject {
    typealias FlickrResponse = (Error?, [FlickrPhoto]?) -> Void
    typealias FlickrImage = (Error?, UIImage?) -> Void
    struct Constants {
        static let flickrApiKey = "c4ab91d735bca1f8dbb4ccb5887cef4f"
        static let flickApiUrl = "https://api.flickr.com/services/rest/"
    }
    

    
    enum Method {
        case search(value: String)
        case recent
        case popular
        
        var methodKey : String {
            switch (self) {
            case .search: return "flickr.photos.search"
            case .recent: return "flickr.photos.getRecent"
            case .popular: return "flickr.interestingness.getList"
            }
        }
    }
    
 
    enum RequestError:Error {
        case noPhoto
        case noInternet
        case invalidResponse
        
        public var errorDescription: String? {
            switch self {
            case .noPhoto :
                return "No Photos found!"
            case .noInternet:
                return "No Internet"
            case .invalidResponse:
                return "Invalid response from flickr"
            }
        }
    }
    
    static func requestPhotos(method: Method, onCompletion: @escaping FlickrResponse) -> Void {
        
        var components = URLComponents(string: Constants.flickApiUrl)
        components?.queryItems = []
        components?.queryItems?.append(URLQueryItem(name: "api_key", value:Constants.flickrApiKey))
        components?.queryItems?.append(URLQueryItem(name: "per_page", value:"30"))
        components?.queryItems?.append(URLQueryItem(name: "format", value:"json"))
        components?.queryItems?.append(URLQueryItem(name: "nojsoncallback", value:"1"))
        components?.queryItems?.append(URLQueryItem(name: "method", value:method.methodKey))
        
        if case .search(let value) = method
        {
            components?.queryItems?.append(URLQueryItem(name: "tags", value: value))
        }
  
        let searchTask = URLSession.shared.dataTask(with: (components?.url)!, completionHandler: {data, response, error -> Void in

            if error != nil {
                print("Error fetching photos: \(String(describing: error))")
                onCompletion(error, nil)
                return
            }

            do {
                let resultsDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject]
                
                guard resultsDictionary != nil else {
                    onCompletion(RequestError.invalidResponse, nil)
                    return
                }
                guard let photosContainer = resultsDictionary!["photos"] as? NSDictionary else {
                     onCompletion(RequestError.invalidResponse, nil)
                    return }
                guard let photosArray = photosContainer["photo"] as? [NSDictionary] else {
                    onCompletion(RequestError.invalidResponse, nil)
                    return }

                let flickrPhotos: [FlickrPhoto] = photosArray.map { photoDictionary in
                    return FlickrPhoto(photoDictionary: photoDictionary)
                }

                onCompletion(nil, flickrPhotos)

            } catch let error as NSError {
                print("Error parsing JSON: \(error)")
                onCompletion(error, nil)
                return
            }

        })
        searchTask.resume()
    }
    
    static func loadImage(url: URL, completion: @escaping FlickrImage) -> Void {
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(nil, cachedImage)
        } else {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print("Failed fetching image:", FlickrConnector.RequestError.noPhoto)
                    completion(FlickrConnector.RequestError.noPhoto, nil)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    print("Not a proper HTTPURLResponse or statusCode")
                    completion(RequestError.invalidResponse, nil)
                    return
                }
                if let data = data, let image = UIImage(data: data) {
                     imageCache.setObject(image, forKey: url.absoluteString as NSString)
                     completion(nil, image)
                }else{
                      completion(RequestError.invalidResponse, nil)
                }
               
                }.resume()
        }
    }
}

