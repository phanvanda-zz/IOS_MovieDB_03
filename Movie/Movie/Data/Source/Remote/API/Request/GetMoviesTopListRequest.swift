//
//  GetMoviesListRequest.swift
//  Movie
//
//  Created by TranCuong on 8/1/18.
//  Copyright © 2018 Tran Cuong. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

class GetMoviesTopListRequest: BaseRequest {
    required init(page: Int) {
        let body: [String: Any] = [
            "api_key": APIKey.key,
             "page" : page,
            "language": "en-US"
        ]
        let url = URLs.apiMovieTopRatedURL
        super.init(url: url, requestType: .get, body: body)
    }
}
