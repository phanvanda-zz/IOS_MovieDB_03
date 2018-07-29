//
//  MoviesByGenresResponse.swift
//  MarvelMovie
//
//  Created by Da on 7/28/18.
//  Copyright © 2018 MarvelMovie. All rights reserved.
//

import Foundation
import ObjectMapper
class MoviesByGenresResponse : Mappable {
    
    var movies = [Movie]()
    
    required init(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        movies <- map["items"]
    }
}
