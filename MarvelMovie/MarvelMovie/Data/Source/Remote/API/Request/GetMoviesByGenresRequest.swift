//
//  GetMoviesByGenresRequest.swift
//  MarvelMovie
//
//  Created by Da on 7/28/18.
//  Copyright © 2018 MarvelMovie. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

class GetMoviesByGenresRequest: BaseRequest {
    
    required init(id: Int) {
        let url = URLs()
        super.init(url: url.geURLtMoviesByGenres(id: id))
        
    }
}
