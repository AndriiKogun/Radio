//
//  MainGenreSectionModel.swift
//  Radio
//
//  Created by Andrii on 08.01.2022.
//

import UIKit

enum GenreType: Int, CaseIterable {
    case all = 0
    case pop
    case rock
    case oldies
    case style
    case dance
    case lounge
    case jazz
    
    var name: String {
        switch self {
        case .all: return "all"
        case .pop: return "pop"
        case .rock: return "rock"
        case .oldies: return "oldies"
        case .style: return "style"
        case .dance: return "dance"
        case .lounge: return "lounge"
        case .jazz: return "jazz"
        }
    }
}

class MainGenreSectionModel: MainSectionBaseModel {
    
    var genres = GenreType.allCases
    
    override var type: MainSectionType {
        return .genre
    }
    
    override func numberOfItems() -> Int {
        return genres.count
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
