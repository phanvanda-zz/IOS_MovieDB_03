//
//  FavoriteTableViewCell.swift
//  Movie
//
//  Created by TranCuong on 8/7/18.
//  Copyright © 2018 Tran Cuong. All rights reserved.
//

import UIKit
import Reusable

class FavoriteTableViewCell: UITableViewCell, NibReusable {
    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet private weak var nameMovieLabel: UILabel!
    @IBOutlet private weak var descriptionMovieLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(movie: Movie?) {
        nameMovieLabel.text = movie?.title
        descriptionMovieLabel.text = movie?.overview
        guard let poster = movie?.posterPath else { return }
        let url = URL(string: URLs.posterImage + poster)
        movieImageView.sd_setImage(with: url, completed: nil)
    }
}
