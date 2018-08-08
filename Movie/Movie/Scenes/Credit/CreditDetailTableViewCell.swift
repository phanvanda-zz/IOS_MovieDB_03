//
//  CreditDetailTableViewCell.swift
//  Movie
//
//  Created by Da on 8/6/18.
//  Copyright © 2018 Tran Cuong. All rights reserved.
//

import UIKit
import Reusable
import SDWebImage
import Cosmos

class CreditDetailTableViewCell: UITableViewCell, NibReusable {
    @IBOutlet private weak var backdropImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var cosmosView: CosmosView!
    @IBOutlet private weak var voteLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var popularLabel: UILabel!
    
    var movie: Movie?
    
    private struct ConstantString {
        static let placeBirth = "Place birth: "
        static let date = "Release date: "
        static let populary = "Popularity: "
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func updateCell(movie: Movie) {
        let poster = movie.posterPath
        let vote = movie.vote
        let url = URL(string: URLs.posterImage + poster)
        self.movie = movie
        backdropImageView.sd_setImage(with: url, completed: nil)
        nameLabel.text = movie.title
        voteLabel.text = "( \(vote) )"
        dateLabel.text = ConstantString.date + movie.releaseDate
        cosmosView.rating = vote / 2
        popularLabel.text = ConstantString.populary + String(movie.popularity)
    }
}
