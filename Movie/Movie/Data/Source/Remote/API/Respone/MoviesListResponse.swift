//
//  MoviesListResponse.swift
//  Movie
//
//  Created by Da on 7/31/18.
//  Copyright © 2018 Tran Cuong. All rights reserved.
//

import Foundation
import ObjectMapper

class MoviesListResponse : Mappable {
    var id = Int()
    var movies = [Movie]()
    
    required init(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        movies <- map["results"]
    }
}
