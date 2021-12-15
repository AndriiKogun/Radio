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
    func loadList(groupID: Int, handler: @escaping (Result <List, String>) -> Void)
}

enum Result<T, U> {
    case success(T)
    case error(U)
    case noConnection
}

class NetworkService: NetworkServiceProtocol {
    
    private let baseUrl = "https://api.partizancloud.com/"
    private let clientKey = "42f6c432fdb71b1ed20874b181352a14"
    
    private let serverError = "Щось пішло не так"
    
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
    
    func loadList(groupID: Int, handler: @escaping (Result <List, String>) -> Void) {
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
