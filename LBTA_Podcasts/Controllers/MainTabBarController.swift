//
//  ViewController.swift
//  LBTA_Podcasts
//
//  Created by Vlado Velkovski on 9/17/18.
//  Copyright © 2018 Vlado Velkovski. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControllers()
        
    }
    
    //MARK:- Setup Functions
    
    func setupViewControllers() {
        viewControllers = [
            generateNavigationVontroller(with: PodcastsSearchController(), title: "Search", image: "search"),
            generateNavigationVontroller(with: FavoritesViewController(), title: "Favorites", image: "favorites"),
            generateNavigationVontroller(with: DownloadsViewController(), title: "Downloads", image: "downloads")
        ]

    }
    
    //MARK:- Helper Functions
    
    fileprivate func generateNavigationVontroller(with rootViewController: UIViewController, title: String, image: String) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        rootViewController.navigationItem.title = title
        navController.navigationBar.prefersLargeTitles = true
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: image)
        return navController
    }
    
}

