//
//  TabbarViewController.swift
//  MovieDB
//
//  Created by le.n.t.trung on 03/11/2022.
//

import UIKit

final class TabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configTabbar()
    }

    private func configTabbar() {
        self.tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = .gray
        tabBar.backgroundColor = .black
        self.viewControllers = [
            configSubNavigationController(viewController: HomeViewController(),
                                          item: TabbarItem.home.item,
                                          title: TabbarItemTitle.home.rawValue),
            configSubNavigationController(viewController: SearchViewController(),
                                          item: TabbarItem.category.item,
                                          title: TabbarItemTitle.category.rawValue),
            configSubNavigationController(viewController: TrendingViewController(),
                                          item: TabbarItem.trending.item,
                                          title: TabbarItemTitle.trending.rawValue),
            configSubNavigationController(viewController: FavoriteViewController(),
                                          item: TabbarItem.favoriteList.item,
                                          title: TabbarItemTitle.myList.rawValue)
        ]
    }

    private func configSubNavigationController(viewController: UIViewController,
                                               item: UITabBarItem,
                                               title: String) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = item
        navigationController.tabBarItem.title = title
        return navigationController
    }
}
