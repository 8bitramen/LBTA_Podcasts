//
//  FavoriteCell.swift
//  LBTA_Podcasts
//
//  Created by Vlado Velkovski on 10/3/18.
//  Copyright © 2018 Vlado Velkovski. All rights reserved.
//

import UIKit


class FavoriteCell: UICollectionViewCell {
    
    //MARK:- Properties
    
    var podcast: Result.Podcast! {
        didSet {
            favoritePodcastLabel.text = podcast.name
            favoritePodcastAuthor.text = podcast.artistName
            let url = URL(string: podcast.artWork ?? "")
            favoriteImageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    let favoriteImageView: UIImageView = {
        let fiv = UIImageView(image: UIImage(named: "downloads"))
        fiv.contentMode = .scaleAspectFit
//        fiv.backgroundColor = .yellow
        fiv.translatesAutoresizingMaskIntoConstraints = false
        return fiv
    }()
    
    let favoritePodcastLabel: UILabel = {
        let fpl = UILabel()
        fpl.text = "Podcast Name"
        fpl.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        fpl.translatesAutoresizingMaskIntoConstraints = false
        return fpl
    }()
    
    let favoritePodcastAuthor: UILabel = {
        let fpa = UILabel()
        fpa.textColor = .lightGray
        fpa.text = "Podcast Author"
        fpa.font = UIFont.systemFont(ofSize: 14)
        fpa.translatesAutoresizingMaskIntoConstraints = false
        return fpa
    }()

    // MARK:- Initialisation
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
//        setupFavoriteImageView()
//        setupFavoritePodcastLabel()
//        setupFavoritePodcastAuthor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI() {
        favoriteImageView.heightAnchor.constraint(equalTo: favoriteImageView.widthAnchor).isActive = true
        let verticalStackView = UIStackView(arrangedSubviews: [favoriteImageView, favoritePodcastLabel, favoritePodcastAuthor])
        verticalStackView.axis = .vertical
        //        verticalStackView.spacing = 10
        addSubview(verticalStackView)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.distribution = .fill
        
        verticalStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        favoritePodcastLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        favoritePodcastAuthor.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }

    
//    fileprivate func setupFavoriteImageView() {
//        addSubview(favoriteImageView)
//        favoriteImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
//        favoriteImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//        favoriteImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
////        favoriteImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//        favoriteImageView.heightAnchor.constraint(equalToConstant: frame.height - 40).isActive = true
//    }
//
//    fileprivate func setupFavoritePodcastLabel() {
//        addSubview(favoritePodcastLabel)
//        favoritePodcastLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
//        favoritePodcastLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//        favoritePodcastLabel.topAnchor.constraint(equalTo: favoriteImageView.bottomAnchor, constant: -8).isActive = true
//    }
//
//    fileprivate func setupFavoritePodcastAuthor() {
//        addSubview(favoritePodcastAuthor)
//        favoritePodcastAuthor.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
//        favoritePodcastAuthor.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//        favoritePodcastAuthor.topAnchor.constraint(equalTo: favoritePodcastLabel.bottomAnchor, constant: -8).isActive = true
//        favoritePodcastAuthor.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//
//
//    }
    
    
}
