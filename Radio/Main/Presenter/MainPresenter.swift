//
//  MainPresenter.swift
//  Radio
//
//  Created by Andrii on 27.12.2021.
//

import Foundation
import AVFoundation
import SwiftSoup

protocol MainControllerProtocol: AnyObject {
    func reloadData()
    func showPlayer(track: Track)
}

protocol MainPresenterProtocol: AnyObject {
    
    init(view: MainControllerProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol)
    var stations: [Station] { get set }
    func loadData()
    func getCurrentTrack(stationID: String)
}

class MainPresenter: MainPresenterProtocol {
    weak var view: MainControllerProtocol?
    
    var networkService: NetworkServiceProtocol
    var router: RouterProtocol
    var stations = [Station]()

    required init(view: MainControllerProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol) {
        self.view = view
        self.networkService = networkService
        self.router = router
    }

    func loadData() {
        networkService.loadStations(genre: .rock, page: 0) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let stations):
                self.stations = stations
                self.view?.reloadData()
            default:
                break
            }
        }
    }
    
    func getCurrentTrack(stationID: String) {
        networkService.getCurrentTrack(stationID: stationID) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let track):
                self.view?.showPlayer(track: track)
            default:
                break
            }
        }
    }
    
}
