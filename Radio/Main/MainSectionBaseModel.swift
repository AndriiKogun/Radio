//
//  MainSectionBaseModel.swift
//  Radio
//
//  Created by Andrii on 08.01.2022.
//

import UIKit

enum MainSectionType: Int, CaseIterable {
    case header
    case favorites
    case genre
    case stations
}

class MainSectionBaseModel {
    
    var type: MainSectionType {
        return .header
    }
    
    func numberOfItems() -> Int {
        return 0
    }
    
    func sectionLayout() -> NSCollectionLayoutSection {
        let group = NSCollectionLayoutGroup(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)) )
        return NSCollectionLayoutSection(group: group)
    }
}
