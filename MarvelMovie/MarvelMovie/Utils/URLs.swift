//
//  URLs.swift
//  MarvelMovie
//
//  Created by Da on 7/27/18.
//  Copyright © 2018 MarvelMovie. All rights reserved.
//

import Foundation
struct URLs {
    private static var APIBaseUrl = "https://api.themoviedb.org/3"
    fileprivate static var APIKey = "?api_key=c80ec9d27d4803e8381e5574720199e2&language=en-US"
    public static let APIGetGenresUrl = APIBaseUrl + "/genre/movie/list" + URLs.APIKey
    public static let APISearchUserUrl = APIBaseUrl + "/search/company" + URLs.APIKey
    public static let APIGetMoviesByGenres = APIBaseUrl + "/list/"
    public func geURLtMoviesByGenres(id: Int) -> String {
        var url = URLs.APIGetMoviesByGenres
        url = url + "\(id)" + URLs.APIKey
        return url
    }
}
