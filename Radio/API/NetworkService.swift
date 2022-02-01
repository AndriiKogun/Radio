//
//  NetworkService.swift
//  Radio
//
//  Created by Andrii on 14.12.2021.
//

import Foundation

import Alamofire

protocol NetworkServiceProtocol {
    func loadStations(genre: GenreType, page: Int, completion: @escaping (Result <[Station], String> ) -> Void)
    func getCurrentTrack(stationID: String, completion: @escaping (Result <Track, String>) -> Void)

    func loadAllStations(page: Int)
    func loadCountries(region: String)

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
//        let urlString: String
//            if page == 0 {
//                urlString = "\(baseUrl)/\(country)/?cs=ua.hit.fm&ajax=1&tzLoc=Europe/Kiev"
//
//            } else {
//                urlString = "\(baseUrl)/\(country)/?cs=ua.hit.fm&p=\(page)&ajax=1&tzLoc=Europe/Kiev"
//
//            }
//        \(page)
        let urlString = "https://onlineradiobox.com/de/?cs=ee.doubleclap&p=\(page)&tzLoc=Europe/Kiev&ajax=1&tzLoc=Europe/Kiev"
        
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
                
                self.currentPage += 1
                
                let stations = HTMLParser.shared.getStetions(html: model.data)
                                
                if let stationsCount = self.stationsCount, self.currentPage > stationsCount {
                    HTMLParser.shared.saveToTetFile()
                    HTMLParser.shared.saveToData()
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        self.loadAllStations(page: self.currentPage)
                        print("---------------- GET request for next page NUMBER \(self.currentPage)")
                    }
                }
            })
        }
    }
    
    func loadCountries(region: String) {
        let urlString = "https://onlineradiobox.com/Europe/?cs=ua.radio.roks&ajax=1&tzLoc=Europe/Kiev"

        AF.request(urlString,
                   method: .get,
                   encoding: JSONEncoding.default).responseJSON { [weak self] response in
            
            guard
                let self = self,
                let data = response.data,
                let model = try? JSONDecoder().decode(DataModel.self, from: data)
            else {
                return// completion(.error(self?.serverError ?? ""))
            }

            HTMLParser.shared.getCountries(html: model.data)
            
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
}
