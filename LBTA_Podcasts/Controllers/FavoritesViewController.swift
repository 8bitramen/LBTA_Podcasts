//
//  FavoritesViewController.swift
//  LBTA_Podcasts
//
//  Created by Vlado Velkovski on 9/17/18.
//  Copyright © 2018 Vlado Velkovski. All rights reserved.
//

import UIKit

class FavoritesViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //MARK:- Properties
    
    var podcasts = UserDefaults.standard.savedPodcasts()
    
    fileprivate let cellId = "cellId"
    
    //MARK:- Set-Up
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupLongTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(FavoriteCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    fileprivate func setupLongTapGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector (handleDeletePodcast))
        collectionView.addGestureRecognizer(longPressGesture)
        
    }
    
    //MARK:- Handlers
    
    @objc func handleDeletePodcast(gesture: UIGestureRecognizer) {
        let point = gesture.location(in: collectionView)
        print(point.x, point.y)
        let indexPath = collectionView.indexPathForItem(at: point)
        guard let selectedIndexPath = indexPath else { return }
        let podcast = podcasts[selectedIndexPath.item]
        print("Selected: \(podcast.name ?? "")")
        
        
        let alertController = UIAlertController(title: "Remove \(podcast.name ?? "") from Favorites?", message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Yes", style: .destructive) { (_) in
            // delete the podcast here
            print("Deleting podcast ...!!!")
            let deleteIndex = self.podcasts.index(of: podcast)
            self.podcasts.remove(at: deleteIndex!)
            self.collectionView.deleteItems(at: [selectedIndexPath])
            
            var listOfPodcasts = UserDefaults.standard.savedPodcasts()
            listOfPodcasts = self.podcasts
            
            let data = NSKeyedArchiver.archivedData(withRootObject: listOfPodcasts)
            UserDefaults.standard.set(data, forKey: UserDefaults.favoritedPodcastKey)
            
            //                self.collectionView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            // cancel action code
        }
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    //MARK:- CollectionView delegates / spacing implementation
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FavoriteCell
        let podcast = self.podcasts[indexPath.item]
        cell.podcast = podcast
        //        cell.backgroundColor = .red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3 * 16) / 2
        return CGSize(width: width, height: width + 46)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
