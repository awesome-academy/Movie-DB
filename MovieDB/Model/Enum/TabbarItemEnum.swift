//
//  TabbarItemEnum.swift
//  MovieDB
//
//  Created by le.n.t.trung on 03/11/2022.
//

import Foundation
import UIKit

enum TabbarItem {
    case home
    case category
    case trending
    case favoriteList
    
    var item: UITabBarItem {
        switch self {
        case .home:
            return UITabBarItem(title: "",
                                image: UIImage(named: "home_icon_tabbar"),
                                tag: 1)
        case .category:
            return UITabBarItem(title: "",
                                image: UIImage(named: "category_icon_tabbar"),
                                tag: 2)
        case .trending:
            return UITabBarItem(title: "",
                                image: UIImage(named: "trending_icon_tabbar"),
                                tag: 3)
        case .favoriteList:
            return UITabBarItem(title: "",
                                image: UIImage(named: "favorite_icon_tabbar"),
                                tag: 4)
        }
    }
}
