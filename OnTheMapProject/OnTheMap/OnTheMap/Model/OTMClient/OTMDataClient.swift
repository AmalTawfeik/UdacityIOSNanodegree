//
//  OTMDataClient.swift
//  OnTheMap
//
//  Created by Amal Tawfeik on 01.05.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

class OTMDataClient {
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1/StudentLocation"
        
        case getStudentsData
        case addLocation
        case ediLocation
        
        var stringValue: String {
            switch self {
            case .getStudentsData:
                return Endpoints.base + "?limit=100&order=-updatedAt"
            case .addLocation:
                return Endpoints.base
            case .ediLocation:
                return Endpoints.base + "/\(OTMUserDefaults.getOTMUserDefaults(OTMUserDefaults.objectIdKey)!)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
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
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
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
    }
    
    class func taskForPUTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
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
    }
    class func getStudentsData(completion: @escaping ([StudentsDataModel]?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getStudentsData.url, responseType: StudentsDataResponse.self) { response, error in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func addLocation(uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double, completion: @escaping (AddLocationResponse?, Error?) -> Void) {
        let body = AddLocationRequest(uniqueKey: uniqueKey, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude)
        taskForPOSTRequest(url: Endpoints.addLocation.url, responseType: AddLocationResponse.self, body: body) { response, error in
            if let response = response {
                OTMUserDefaults.saveOTMUserDefaults(key: OTMUserDefaults.objectIdKey, value: response.objectId)
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func editUserLocation(uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double, completion: @escaping (EditLocationResponse?, Error?) -> Void) {
        let body = AddLocationRequest(uniqueKey: uniqueKey, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude)
        taskForPUTRequest(url: Endpoints.ediLocation.url, responseType: EditLocationResponse.self, body: body) { response, error in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }

}



