//
//  MainPresenter.swift
//  Radio
//
//  Created by Andrii on 27.12.2021.
//

import Foundation
import AVFoundation
import SwiftSoup

protocol MainPresenterProtocol: AnyObject {
    
    init(view: MainControllerProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol)

    func loadStations(genre: GenreType, page: Int)
    func getCurrentTrack(stationID: String)
}

class MainPresenter: MainPresenterProtocol {
    
    weak var view: MainControllerProtocol?
    
    var networkService: NetworkServiceProtocol
    var router: RouterProtocol
    var stations = [Station]()
    var sections = [MainSectionBaseModel]()

    required init(view: MainControllerProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol) {
        self.view = view
        self.networkService = networkService
        self.router = router
    }
    var data = ""

    func loadStations(genre: GenreType, page: Int) {
        networkService.loadAllStations(page: 0)
        
//        stations = HTMLParser.shared.readFromFile()

        sections = [
            MainGenreSectionModel(),
            MainStationsSectionModel(stations: stations)
        ]
        
        
        view?.reloadData()
        
//        networkService.loadStations(genre: genre, page: page) { [weak self] result in
//            guard let self = self else { return }
//
//            switch result {
//            case .success(let stations):
//                self.stations.append(contentsOf: stations)
//                self.view?.reloadData()
//
//
//
//            default:
//                break
//            }
//        }
    }
    
    func getCurrentTrack(stationID: String) {
        networkService.getCurrentTrack(stationID: stationID) { [weak self] result in
            guard let self = self else { return }

            guard var station = self.stations.first(where: { $0.id == stationID }) else {return}

            switch result {
            case .success(let track):
                station.currentTrack = track
            default:
                break
            }
            self.view?.updateMiniPlayer(station: station)
        }
    }
}
