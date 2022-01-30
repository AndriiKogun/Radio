//
//  NetworkService.swift
//  Radio
//
//  Created by Andrii on 14.12.2021.
//

import Foundation

import Alamofire

protocol NetworkServiceProtocol {
    func login(login: String, password: String, handler: @escaping (Result <LoginModel, String>) -> Void)
    func loadList(groupID: Int, handler: @escaping (Result <Station, String>) -> Void)
    
    func loadStations(genre: GenreType, page: Int, completion: @escaping (Result <[Station], String> ) -> Void)
    func getCurrentTrack(stationID: String, completion: @escaping (Result <Track, String>) -> Void)

    func loadAllStations(page: Int)

}

enum Result<T, U> {
    case success(T)
    case error(U)
    case noConnection
}

class NetworkService: NetworkServiceProtocol {
        
    private let baseUrl = "https://onlineradiobox.com"
    private let country = "ua"
    
    private let serverError = "Щось пішло не так"
    
    var currentPage = 0
    var stationsCount: Int?
    
    func loadStations(genre: GenreType, page: Int, completion: @escaping (Result <[Station], String>) -> Void) {
        guard page <= 11 else { return }
        let urlString: String
//        if genre == .all {
//            if page == 0 {
//                urlString = "\(baseUrl)/\(country)/?cs=ua.hit.fm&ajax=1&tzLoc=Europe/Kiev"
//
//            } else {
//                urlString = "\(baseUrl)/\(country)/?cs=ua.hit.fm&p=\(page)&ajax=1&tzLoc=Europe/Kiev"
//
//            }
//        } else {
//            urlString = "\(baseUrl)/\(country)/genre/\(genre.name)-/?cs=ua.hit.fm&p=\(page)&ajax=1&tzLoc=Europe/Kiev"
//        }
        
        urlString = "https://onlineradiobox.com/pl/?cs=ua.radio.roks&p=0&tzLoc=Europe/Kiev&ajax=1&tzLoc=Europe/Kiev"
         
        AF.request(urlString,
                   method: .get,
                   encoding: JSONEncoding.default).responseJSON { [weak self] response in
            
            guard
                let self = self,
                let data = response.data,
                let model = try? JSONDecoder().decode(DataModel.self, from: data)
            else {
                return completion(.error(self?.serverError ?? ""))
            }
            
            let stations = HTMLParser.shared.getStetions(html: model.data)
            completion(.success(stations))
        }
    }
    
    func loadAllStations(page: Int) {
        let urlString: String
            if page == 0 {
                urlString = "\(baseUrl)/\(country)/?cs=ua.hit.fm&ajax=1&tzLoc=Europe/Kiev"

            } else {
                urlString = "\(baseUrl)/\(country)/?cs=ua.hit.fm&p=\(page)&ajax=1&tzLoc=Europe/Kiev"

            }
        
//        var urlString = "https://onlineradiobox.com/ua/?cs=jp.moonmission&p=1&ajax=1&tzLoc=Europe/Kiev"
         
        AF.request(urlString,
                   method: .get,
                   encoding: JSONEncoding.default).responseJSON { [weak self] response in
            
            guard
                let self = self,
                let data = response.data,
                let model = try? JSONDecoder().decode(DataModel.self, from: data)
            else {
                return
            }
            
            DispatchQueue.main.async(execute: {
                if self.stationsCount == nil {
                    self.stationsCount = HTMLParser.shared.numberOfPages(html: model.data)
                }
                
                
                let stations = HTMLParser.shared.getStetions(html: model.data)

                
                self.currentPage += 1
                
                if let stationsCount = self.stationsCount, self.currentPage > stationsCount {
                    HTMLParser.shared.save()
                    HTMLParser.shared.saveToData()

                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        self.loadAllStations(page: self.currentPage)
                        print("---------------- gte request for next page")
                    }
                }
            })
        }
    }

    
    func getCurrentTrack(stationID: String, completion: @escaping (Result <Track, String>) -> Void) {
        let urlString = "https://scraper2.onlineradiobox.com/\(stationID)?l=0"
        
        AF.request(urlString,
                   method: .get,
                   encoding: JSONEncoding.default).responseJSON { [weak self] response in
            
            guard
                let self = self,
                let data = response.data,
                let track = try? JSONDecoder().decode(Track.self, from: data)
            else {
                return completion(.error(self?.serverError ?? ""))
            }
                        
            completion(.success(track))
        }
    }
    
    func login(login: String, password: String, handler: @escaping (Result <LoginModel, String>) -> Void) {
//        let jsonString = "json={\("client_key=\(clientKey),email=\(login),password=\(password)")}"
//
//        let request = getRequest(path: "rest/securityLogin",
//                                 httpMethod: HTTPMethod.post.rawValue,
//                                 jsonString: jsonString)
//
//        AF.request(request).responseJSON { [weak self] (response) in
//
//            guard
//                let self = self,
//                let data = response.data,
//                let model = try? JSONDecoder().decode(LoginModel.self, from: data)
//            else {
//                return handler(.error(self?.serverError ?? ""))
//            }
//            self.saveCookies(response: response.response)
//            handler(.success(model))
//        }
    }
    
    
    
    
    func loadList(groupID: Int, handler: @escaping (Result <Station, String>) -> Void) {
//        let jsonString = "json={\("group_id=\(groupID)")}"
//
//        let request = getRequest(path: "restProtected/getUserDeviceListDirContent",
//                                 httpMethod: HTTPMethod.post.rawValue,
//                                 jsonString: jsonString)
//
//        AF.request(request).responseJSON { (response) in
//            guard let data = response.data, let model = try? JSONDecoder().decode(List.self, from: data) else {
//                return handler(.error(self.serverError))
//            }
//            handler(.success(model))
//        }
    }
}

extension NetworkService {
//    private func getRequest(path: String, httpMethod: String, jsonString: String) -> URLRequest {
        
//        let url = URL(string: baseUrl + path)!
//        var request = URLRequest(url: url)
//        request.httpMethod = httpMethod
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//        request.httpBody = jsonString.data(using: .utf8)
//
//        if let properties = Defaults.value(forKey: Constants.SESSION_ID) as? [HTTPCookiePropertyKey : AnyObject] {
//            if let cookie = HTTPCookie(properties: properties) {
//                let headers = HTTPCookie.requestHeaderFields(with: [cookie])
//                request.allHTTPHeaderFields = headers
//            }
//        }
//
//        return request
//    }

    private func saveCookies(response: HTTPURLResponse?) {
//        guard
//            let headerFields = response?.allHeaderFields as? [String: String],
//            let url = response?.url,
//            let cookie = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: url).first(where: { $0.name == "JSESSIONID" })
//        else {
//            return
//        }
//        Defaults.set(cookie.properties, forKey: Constants.SESSION_ID)
    }
}
