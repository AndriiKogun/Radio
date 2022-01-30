//
//  MainGenreSectionModel.swift
//  Radio
//
//  Created by Andrii on 08.01.2022.
//

import UIKit

enum GenreType: String {
    case all = "all"
    case pop = "pop"
    case rock = "rock"
    case electronic = "electronic"
    case religious = "religious"
    case easylistening = "easylistening"
    case folk = "folk"
    case newstalk = "news"
    case international = "international"
    case classic = "retro"
    case jazzfunk = "jazz"
    case other = "other"
    
    var name: String {
        switch self {
        case .all: return "all"
        case .pop: return "pop"
        case .rock: return "rock"
        case .classic: return "retro"
        case .electronic: return "dance"
        case .religious: return "religion"
        case .easylistening: return "lounge"
        case .folk: return "folk"
        case .newstalk: return "news"
        case .international: return "international"
        case .jazzfunk: return "jazz"
        case .other: return "other"
        }
    }
    
    var keyValue: String {
        switch self {
        case .all: return ""
        case .pop: return "pop-"
        case .rock: return "rock-"
        case .electronic: return "electronic-"
        case .religious: return "religious-"
        case .easylistening: return "easylistening-"
        case .folk: return "folk-"
        case .newstalk: return "newstalk-"
        case .international: return "international-"
        case .classic: return "classic-"
        case .jazzfunk: return "jazzfunk-"
        case .other: return "other-"
        }
    }
    
}

class MainGenreSectionModel: MainSectionBaseModel {
    
    var genres = [GenreType]()
    
    override var type: MainSectionType {
        return .genre
    }
    
    override func numberOfItems() -> Int {
        return 0
    }
    
    override func sectionLayout() -> NSCollectionLayoutSection {
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
        section.interGroupSpacing = 10
        return section
    }
}
