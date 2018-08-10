//
//  MovieCollectionViewCell.swift
//  Movie
//
//  Created by Da on 7/31/18.
//  Copyright © 2018 Tran Cuong. All rights reserved.
//

import UIKit
import SDWebImage
import Reusable
import Cosmos
import os_object

class MovieCollectionViewCell: UICollectionViewCell, NibReusable {
    
    // MARK: OUTLET
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var cosmosView: CosmosView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    // MARK: VARIABLES
    var movie: Movie?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateCell(movie: Movie?) {
        self.movie = movie
        self.titleLabel.text = movie?.title
        guard let poster = movie?.posterPath, let vote = movie?.vote else { return }
        let url = URL(string: URLs.posterImage + poster)
        posterImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "not_found"), options: .allowInvalidSSLCertificates, completed: nil)
        cosmosView.rating = vote / 2
    }
}
