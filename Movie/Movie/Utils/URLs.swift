//
//  URLs.swift
//  Movie
//
//  Created by Da on 7/31/18.
//  Copyright © 2018 Tran Cuong. All rights reserved.
//

import Foundation

struct URLs {
    private static var apiBaseUrl = "https://api.themoviedb.org/3"
    
    public static let apiGetMovies = apiBaseUrl + "/genre/"

    public static let apiGetGenresUrl = apiBaseUrl + "/genre/movie/list"
    
    public static let apiSearchUserUrl = apiBaseUrl + "/search/company"
    
    public static let apiGetMoviesByGenres = apiBaseUrl + "/list/"
    
    static let apiMovieTopRatedURL = apiBaseUrl + "/movie/top_rated"
    
    static let apiMoviePopularURL = apiBaseUrl + "/movie/popular"
    
    static let apiMovieUpcomingURL = apiBaseUrl + "/movie/upcoming"
    
    public static let apiGetId = apiBaseUrl + "/movie/"
    
    public static let apiGetCredit = apiBaseUrl + "/movie/"
    
    public static let apiGetMoviesByCredit = apiBaseUrl + "/person/"
    
    public static let posterImage = "https://image.tmdb.org/t/p/w300_and_h450_bestv2"
    
    public static let backdropImage = "https://image.tmdb.org/t/p/original"
    
    static let apiMovieSearch = apiBaseUrl + "/search/movie"
}
