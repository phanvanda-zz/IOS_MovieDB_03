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
    
    var movie: Movie?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(movie: Movie?) {
        guard let movieValue = movie,
        let poster = movie?.posterPath,
        let title = movie?.title,
        let overview = movie?.overview
        else { return }
        let url = URL(string: URLs.posterImage + poster)
        nameMovieLabel.text = title
        descriptionMovieLabel.text = overview
        movieImageView.sd_setImage(with: url, completed: nil)
        self.movie = movieValue
    }
}
