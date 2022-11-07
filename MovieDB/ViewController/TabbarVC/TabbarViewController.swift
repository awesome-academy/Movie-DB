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
            configSubNavigationController(viewController: HomeViewController(), item: TabbarItem.home.item),
            configSubNavigationController(viewController: CategoryViewController(), item: TabbarItem.category.item),
            configSubNavigationController(viewController: ComingSoonViewController(), item: TabbarItem.comingSoon.item),
            configSubNavigationController(viewController: FavoriteViewController(), item: TabbarItem.favoriteList.item)
        ]
    }

    private func configSubNavigationController(viewController: UIViewController,
                                               item: UITabBarItem) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = item
        return navigationController
    }
}
