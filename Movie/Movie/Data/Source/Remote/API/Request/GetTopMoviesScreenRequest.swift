//
//  GetTopMoviesScreenRequest.swift
//  Movie
//
//  Created by Da on 8/10/18.
//  Copyright © 2018 Tran Cuong. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

class GetTopMoviesScreenRequest: BaseRequest {
    required init(url: String, page: Int) {
        let body: [String: Any] = [
            "api_key": APIKey.key,
            "page" : page,
            "language": "en-US"
        ]
        let url = url
        super.init(url: url, requestType: .get, body: body)
    }
}

