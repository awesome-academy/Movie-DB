//
//  CompositionalLayout.swift
//  MovieDB
//
//  Created by le.n.t.trung on 09/11/2022.
//

import Foundation
import UIKit

struct CompositionalLayout {
    static func createItem(width: NSCollectionLayoutDimension,
                           height: NSCollectionLayoutDimension,
                           spacingLeft: CGFloat = 0,
                           spacingTop: CGFloat = 0,
                           spacingBottom: CGFloat = 0,
                           spacingRight: CGFloat = 0) -> NSCollectionLayoutItem {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: width,
                                                            heightDimension: height))
        item.contentInsets = NSDirectionalEdgeInsets(top: spacingTop,
                                                     leading: spacingLeft,
                                                     bottom: spacingBottom,
                                                     trailing: spacingRight)
        return item
    }
    
    static func createGroup(width: NSCollectionLayoutDimension,
                            height: NSCollectionLayoutDimension,
                            alignment: CompositionalGroupAlignment,
                            items: [NSCollectionLayoutItem]) -> NSCollectionLayoutGroup {
        switch alignment {
        case .vertical:
            return NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: width,
                                                                                       heightDimension: height),
                                                    subitems: items)
        case .horizontal:
            return NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: width,
                                                                                         heightDimension: height),
                                                      subitems: items)
        }
    }
}
