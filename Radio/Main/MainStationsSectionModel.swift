//
//  MainStationsSectionModel.swift
//  Radio
//
//  Created by Andrii on 08.01.2022.
//

import UIKit

class MainStationsSectionModel: MainSectionBaseModel {
    
    let stations: [Station]
    
    init(stations: [Station]) {
        self.stations = stations
    }
    
    override var type: MainSectionType {
        return .stations
    }
    
    override func numberOfItems() -> Int {
        return stations.count
    }
    
    override func sectionLayout() -> NSCollectionLayoutSection {
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
}
