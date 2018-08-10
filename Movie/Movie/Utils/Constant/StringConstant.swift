//
//  StringConstant.swift
//  Movie
//
//  Created by Da on 8/11/18.
//  Copyright © 2018 Tran Cuong. All rights reserved.
//
import Foundation
import UIKit

struct nameDatabase {
    static let movieDatabase = "FavoriteMovies"
}

struct MovieInfoDB {
    static let movieId = "movieId"
    static let title = "title"
    static let overview = "overview"
    static let posterPath = "posterPath"
    static let date = "date"
    static let vote = "vote"
    static let popularity = "popularity"
}

struct ConstantString {
    static let loadStr = "Loading..."
    static let hide = "Hide"
    static let seemore = "Seemore"
    static let added = "Added to the favorites list"
    static let removed = "Removed from the favorites list"
}

struct IdentifierScreen {
    static let loadMore = "LoadMoreViewController"
    static let movieDetail = "MovieDetailViewController"
    static let credit = "CreditDetailViewController"
}
