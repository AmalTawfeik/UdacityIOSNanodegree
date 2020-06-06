//
//  VTFlickerClient.swift
//  VirtualTourist
//
//  Created by Amal Tawfeik on 18.05.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

class VTFlickerClient {
    static let apiKey = "fd356c97e3ca695e1fa330a8a1be773a"
    static let apiSecret = "dc1ac4e553abea20"

    enum Endpoints {
        static let base = "https://api.flickr.com/services/rest/"
        static let photoSearch = "flickr.photos.search"
        static let getFlickerPhotos = base + "?method=\(Endpoints.photoSearch)&api_key=\(apiKey)&format=json&nojsoncallback=1"
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        
        return task
    }
        
    class func getFlickerPhotos(latitude: Double, longitude: Double, completion: @escaping ([FlickerPhoto]?, Error?) -> Void) {
        let url = Endpoints.getFlickerPhotos + "&lat=\(latitude)&lon=\(longitude)"
        print(url)
        taskForGETRequest(url: URL(string: url)!, responseType: FlickerPhotosResponse.self) { response, error in
            if let response = response {
                completion(response.photos.photo, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func downloadFlickerPhoto(pinPhoto: PinPhoto, completion: @escaping (Data?, Error?) -> Void) {
        URLSession.shared.dataTask(with: URL(string: pinPhoto.imageUrl ?? "")!) { (data, response, error) in
                if error == nil {
                    completion(data, nil)
                } else {
                    completion(nil, error)
                }
            }
                .resume()
    }


}

