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
let DOMAIN = "https://api.flickr.com/services/rest/?method=flickr.photos.search"

class CloudAPIService: NSObject {
    
    static let shared = CloudAPIService()
    
    func searchPhotos(input: searchInput, completion: @escaping (Result<SearchData, Error>) -> ()) {
        
        let urlString  = DOMAIN + "&api_key=\(APIKEY)&format=json&nojsoncallback=1&text=\(input.content)&per_page=\(input.perPage)"
        
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
    
    func downloadImage(url: URL, handler: @escaping (UIImage?) -> ()) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                handler(image)
            } else {
                handler(nil)
            }
        }
        task.resume()
    }
}
