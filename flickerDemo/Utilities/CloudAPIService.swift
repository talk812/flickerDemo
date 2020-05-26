//
//  CloudAPIService.swift
//  flickerDemo
//
//  Created by william on 2020/5/26.
//  Copyright © 2020 william. All rights reserved.
//

import Foundation
import UIKit

let APIKEY = "cce8072ec7f4dfbe4bd91bde128e2637"
let PASSWORD = "308a5d423a9121dc"
let DOMAIN = "https://api.flickr.com/services/rest/?method=flickr.photos.search"

enum HttpMethod: String {
    case get
    case post
    case put
    case patch
    case delete
}

class CloudAPIService: NSObject {
    
    static let shared = CloudAPIService()
    
    func searchPhotos(Content: String, NumberOfPages: Int, completion: @escaping (Result<SearchData, Error>) -> ()) {
        
        let urlString  = DOMAIN + "&api_key=\(APIKEY)&format=json&nojsoncallback=1&text=\(Content)&page=\(String(NumberOfPages))"
        
        if let url = URL.init(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, responce, error) in
                if let data = data {
                    do {
                        let photoData = try JSONDecoder().decode(SearchData.self, from: data)
                        completion(.success(photoData))
                    } catch {
                        print(error.localizedDescription)
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(error!))
                }
            }.resume()
        }
    }
}
