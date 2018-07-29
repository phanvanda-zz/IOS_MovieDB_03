//
//  SearchRequest.swift
//  MarvelMovie
//
//  Created by Da on 7/27/18.
//  Copyright © 2018 MarvelMovie. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

class SearchRequest: BaseRequest {
    
    required init(keyword: String, limit: Int) {
        let body: [String: Any]  = [
            "per_page": limit,
            "q": keyword
        ]
        super.init(url: URLs.APISearchUserUrl, requestType: .get, body: body)
    }
}
