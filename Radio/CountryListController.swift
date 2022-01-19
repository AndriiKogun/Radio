//
//  CountryListController.swift
//  Radio
//
//  Created by Andrii on 19.01.2022.
//

import Foundation
import FlagKit

//protocol MainControllerProtocol: AnyObject {
//    func reloadData()
//    func showPlayer(track: Track)
//    func updateMiniPlayer(station: Station)
//
//}

class CountryListController: BaseViewController {
    
    var presenter: MainPresenter!
    var view1: UIView!
       
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let spacing: CGFloat = 10
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(110))
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
            group.interItemSpacing = .fixed(spacing)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
            section.interGroupSpacing = spacing
            return section
        }
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.contentInsetAdjustmentBehavior = .never
        view.delegate = self
        view.dataSource = self
        view.register(StationCell.self, forCellWithReuseIdentifier: StationCell.reuseIdentifier)
        view.register(GenreCell.self, forCellWithReuseIdentifier: GenreCell.reuseIdentifier)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
//        presenter.loadStations(genre: .rock, page: 0)
        
//        view1 = UIView()
//        view1.backgroundColor = .red
//        view.addSubview(view1)
//        view1.centerXToSuperview()
//        view1.bottomToSuperview()
//        view1.height(60)
//        view1.width(60)

    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()

        var insets = view.safeAreaInsets
        insets.bottom = 90
        collectionView.contentInset = insets
    }
    
    private func setupLayout() {
        view.addSubview(collectionView)
        collectionView.topToSuperview()
        collectionView.bottomToSuperview()
        collectionView.leftToSuperview()
        collectionView.rightToSuperview()
    }
    
    override func transition(from fromViewController: UIViewController, to toViewController: UIViewController, duration: TimeInterval, options: UIView.AnimationOptions = [], animations: (() -> Void)?, completion: ((Bool) -> Void)? = nil) {
        
        print("=====")
    }

}

extension CountryListController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StationCell.reuseIdentifier, for: indexPath) as! StationCell
            
            let countryCode = Locale.current.regionCode!
            let flag = Flag(countryCode: "AT")!

            // Retrieve the unstyled image for customized use
            let originalImage = flag.originalImage

            // Or retrieve a styled flag
            let styledImage = flag.image(style: .circle)
            
            cell.stationImageView.image = originalImage
            cell.stationImageView.contentMode = .scaleAspectFill
            cell.stationImageView.backgroundColor = .black
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        if let cell = cell as? StationCell {
            cell.stationImageView.af.cancelImageRequest()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
//            if indexPath.row == presenter.stations.count && presenter.pagesCount * 20  {
//                presenter.loadStations(genre: .rock, page: (presenter.stations.count / 20) - 1)
//            }
        } else {
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let station = presenter.stations[indexPath.row]

        presenter.getCurrentTrack(stationID: station.id)
    }
}
//
//extension MainController: MiniPlayerViewDelegate {
//    func play() {
//        player.player.play()
//    }
//    func pause() {
//        player.player.pause()
//
//    }
//    func share() {
//
//    }
//    func showPlayer(station: Station) {
//        let vc = ViewController(station: station)
//
//        vc.modalPresentationStyle = .overCurrentContext // Disables that black background swift enables by default when presenting a view controller
//
//        present(vc, animated: true, completion: nil)
//    }
//}
//
//
//extension MainController: MainControllerProtocol {
//    func reloadData() {
//        collectionView.reloadData()
//    }
//
//    func updateMiniPlayer(station: Station) {
//        miniPlayerView.isHidden = false
//        miniPlayerView.setup(station: station)
//        miniPlayerView.setup(state: .playing)
//        player.play(station: station)
//    }
//
//    func showPlayer(track: Track) {
////        let vc = ViewController(track: track)
////        view1.willMove(toSuperview: vc.view)
////        view1.didMoveToSuperview()
////        vc.modalPresentationStyle = .overCurrentContext // Disables that black background swift enables by default when presenting a view controller
////
////        present(vc, animated: true, completion: nil)
//    }
//
//}
//
//extension MainController: AudioPlayerDelegate {
//    func audioStream(isLoading: Bool) {
//
//    }
//    func playerDidChange(state: AudioPlayerState) {
//        miniPlayerView.setup(state: state)
//
//    }
//}
