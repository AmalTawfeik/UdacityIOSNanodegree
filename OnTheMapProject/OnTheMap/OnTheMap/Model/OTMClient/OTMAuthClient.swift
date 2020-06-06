//
//  OTMAuthClient.swift
//  OnTheMap
//
//  Created by Amal Tawfeik on 01.05.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

class OTMAuthClient {
    struct Auth {
        static var sessionId = OTMUserDefaults.getOTMUserDefaults(OTMUserDefaults.accountIdKey) ?? ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1/session"

        case login
        case signup
        case getUserData
        case logout

        var stringValue: String {
            switch self {
            case .login:
                return Endpoints.base
            case .signup:
                return "https://auth.udacity.com/sign-up"
            case .getUserData:
                return "https://onthemap-api.udacity.com/v1/users/\(Auth.sessionId)"
            case .logout:
                return Endpoints.base
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
                let range = Range(5..<data.count)
                let newData = data.subdata(in: range)
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
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
                let range = Range(5..<data.count)
                let newData = data.subdata(in: range)
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
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
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let udacityDic = UdacityUserAuthModel(username: username, password: password)
        let body = LoginRequest(udacity: udacityDic)
        taskForPOSTRequest(url: Endpoints.login.url, responseType: LoginResponse.self, body: body) { response, error in
            if let response = response {
                Auth.sessionId = response.account.key
                OTMUserDefaults.saveOTMUserDefaults(key: OTMUserDefaults.accountIdKey, value: response.account.key)
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func getUserData(completion: @escaping (UserDataResponse?, Error?) -> Void) {

        taskForGETRequest(url: Endpoints.getUserData.url, responseType: UserDataResponse.self) { response, error in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }

    class func logout(completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.logout.url)
        request.httpMethod = "DELETE"
        let body = LogoutRequest(sessionId: "\(Auth.sessionId)")
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            Auth.sessionId = ""
            OTMUserDefaults.removeOTMUserDefaults(OTMUserDefaults.accountIdKey)
            OTMUserDefaults.removeOTMUserDefaults(OTMUserDefaults.objectIdKey)

            completion(true, nil)
        }
        task.resume()
    }
    
    
    
}


