//
//  Constant.swift
//  Movie
//
//  Created by Da on 7/31/18.
//  Copyright © 2018 Tran Cuong. All rights reserved.
//

import Foundation
import UIKit

struct Storyboard {
    static let main = "Main"
    static let home = "Home"
    static let topMovie = "TopMovie"
    static let library = "Library"
    static let search = "Search"
    static let feedback = "Feedback"
    
}

struct Storyboard_id {
    static let home = "HomeVC"
    static let topMovie = "TopMovieVC"
    static let library = "LibraryVC"
    static let search = "SearchVC"
    static let feedback = "FeedbackVC"
}

struct cellConstaintSize {
    static let spaceCollectionCell = CGFloat(8)
    static let heightTableCell = CGFloat(30)
    static let spaceItem = CGFloat(0)
    static let spaceLine = CGFloat(0)
    static let minusHeightTable = CGFloat(24)
    static let minus2HeightTable = CGFloat(40)
}

struct IdentifierScreen {
    static let loadMore = "LoadMoreViewController"
    static let movieDetail = "MovieDetailViewController"
    static let credit = "CreditDetailViewController"
}

struct nameDatabase {
    static let movieDatabase = "FavoriteMovies"
}

struct MovieInfoDB {
    static let movieId = "movieId"
    static let title = "title"
    static let overview = "overview"
    static let posterPath = "posterPath"
}

