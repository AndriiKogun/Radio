//
//  MainController.swift
//  Radio
//
//  Created by Andrii on 16.12.2021.
//

import UIKit
import SwiftSoup
import AVKit
import AlamofireImage

enum Section: Int, CaseIterable {
    case grid3
    case grid5

    var columnCount: Int {
        switch self {
        case .grid3:
            return 3
        case .grid5:
            return 5
        }
    }
}

class MainController: BaseViewController {
    
    var presenter: MainPresenter!
    
    
    let player = AVPlayer()
    var playerLayer: AVPlayerLayer!
    
//    private func createLayout() -> UICollectionViewLayout {
//        let spacing: CGFloat = 10
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                              heightDimension: .fractionalHeight(1.0))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                               heightDimension: .absolute(120))
//
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 4) // <---
//        group.interItemSpacing = .fixed(spacing)
//
//        let section = NSCollectionLayoutSection(group: group)
//        section.contentInsets = .init(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
//        section.interGroupSpacing = spacing
//
//        let layout = UICollectionViewCompositionalLayout(section: section)
//        return layout
//    }
    
    private func createLayout() -> UICollectionViewLayout {
            let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
                
                if sectionIndex == 1 {
                    let spacing: CGFloat = 10
                   let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                         heightDimension: .fractionalHeight(1.0))
                   let item = NSCollectionLayoutItem(layoutSize: itemSize)
           
                   let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                          heightDimension: .absolute(120))
           
                   let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 4) // <---
                   group.interItemSpacing = .fixed(spacing)
           
                   let section = NSCollectionLayoutSection(group: group)
                   section.contentInsets = .init(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
                   section.interGroupSpacing = spacing
           
                   return section
                } else {
                    let spacing: CGFloat = 10
                   let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(200),
                                                         heightDimension: .fractionalHeight(1.0))
                   let item = NSCollectionLayoutItem(layoutSize: itemSize)
           
                   let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                          heightDimension: .absolute(32))
           
                   let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                    
//                    horizontal(layoutSize: groupSize, subitem: item, count: 4) // <---
                   group.interItemSpacing = .fixed(spacing)
           
                   let section = NSCollectionLayoutSection(group: group)
                   section.contentInsets = .init(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
                   section.interGroupSpacing = spacing
                    return section
                }
//
//                guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
//                let columns = sectionKind.columnCount
//
//                let itemSize = NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(1.0),
//                    heightDimension: .fractionalHeight(1.0))
//                let item = NSCollectionLayoutItem(layoutSize: itemSize)
//                item.contentInsets = .init(top: 2, leading: 2, bottom: 2, trailing: 2)
//
//                let groupHeight = columns == 1 ?
//                    NSCollectionLayoutDimension.absolute(44) :
//                    NSCollectionLayoutDimension.fractionalWidth(0.2)
//
//                let groupSize = NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(1.0),
//                    heightDimension: groupHeight)
//                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
//
//                let section = NSCollectionLayoutSection(group: group)
//                section.contentInsets = .init(top: 20, leading: 20, bottom: 20, trailing: 20)
//                return section
            }
            return layout
        }

    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.delegate = self
        view.dataSource = self
        view.register(StationCell.self, forCellWithReuseIdentifier: StationCell.reuseIdentifier)
        view.register(GenreCell.self, forCellWithReuseIdentifier: GenreCell.reuseIdentifier)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .yellow
        setupLayout()
        presenter.loadData()
    }
    
    private func setupLayout() {
        view.addSubview(collectionView)
        collectionView.edgesToSuperview()
    }
}

extension MainController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return GenreType.allCases.count
        } else {
            return presenter.stations.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let genre = GenreType.allCases[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCell.reuseIdentifier, for: indexPath) as! GenreCell
            cell.titleLabel.text = genre.name
            return cell
        } else {
            let station = presenter.stations[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StationCell.reuseIdentifier, for: indexPath) as! StationCell
            cell.stationImageView.af.setImage(withURL: URL(string: "https:\(station.imageUrl)")!)
            cell.stationImageView.contentMode = .scaleAspectFill
            cell.stationImageView.backgroundColor = .black
            cell.titleLabel.text = station.name
            return cell
            
        }
        
        
        
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        if let cell = cell as? StationCell {
            cell.stationImageView.af.cancelImageRequest()
        }
    }

}
extension MainController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.stations.count
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let station = presenter.stations[indexPath.row]
//        let cell = tableView.dequeueReusableCell(withIdentifier: StationCell.reuseIdentifier, for: indexPath) as! StationCell
//        cell.stationImageView.af.setImage(withURL: URL(string: "https:\(station.imageUrl)")!)
//        cell.stationImageView.contentMode = .scaleAspectFill
//        cell.stationImageView.backgroundColor = .black
//
//        return cell
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let station = presenter.stations[indexPath.row]

        let asset = AVAsset(url: URL(string: station.stream)!)
        
        let playerItem = AVPlayerItem(asset: asset)
        
        player.replaceCurrentItem(with: playerItem)
        
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.frame
        playerLayer.videoGravity = .resizeAspect
        
        view.layer.addSublayer(playerLayer)
        player.play()
        
        presenter.getCurrentTrack(stationID: station.id)
    }
}

extension MainController: MainControllerProtocol {
    func reloadData() {
        collectionView.reloadData()
    }
    
    func showPlayer(track: Track) {
        let vc = ViewController(track: track)
        present(vc, animated: true, completion: nil)
    }

}
