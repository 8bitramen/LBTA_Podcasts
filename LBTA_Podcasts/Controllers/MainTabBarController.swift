//
//  ViewController.swift
//  LBTA_Podcasts
//
//  Created by Vlado Velkovski on 9/17/18.
//  Copyright © 2018 Vlado Velkovski. All rights reserved.
//

import UIKit

var maximizedPlayerViewTopAnchor: NSLayoutConstraint!
var minimizedPlayerViewTopAnchor: NSLayoutConstraint!


class MainTabBarController: UITabBarController {

//    var maximizedPlayerViewTopAnchor: NSLayoutConstraint!
//    var minimizedPlayerViewTopAnchor: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControllers()
        
        setupPlayerDetailsView()
        
//        perform(#selector(maximizePlayerDetails), with: nil, afterDelay: 2)
        
    }
    
    //MARK:- Setup Functions
    
    func setupViewControllers() {
        let layout = UICollectionViewFlowLayout()
        let favoritesViewController = FavoritesViewController(collectionViewLayout: layout)
        
        viewControllers = [
             generateNavigationVontroller(with: favoritesViewController, title: "Favorites", image: "favorites"),
             generateNavigationVontroller(with: PodcastsSearchController(), title: "Search", image: "search"),
             generateNavigationVontroller(with: DownloadsViewController(), title: "Downloads", image: "downloads")
        ]
    }
    
    fileprivate func setupPlayerDetailsView() {
        let playerDetailsView = PlayerDetailsView.shared
        playerDetailsView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(playerDetailsView, belowSubview: tabBar)
        
        maximizedPlayerViewTopAnchor = playerDetailsView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        minimizedPlayerViewTopAnchor = playerDetailsView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        
        maximizedPlayerViewTopAnchor.isActive = true
        minimizedPlayerViewTopAnchor.isActive = false
        
        playerDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        playerDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -64).isActive = true
        
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

