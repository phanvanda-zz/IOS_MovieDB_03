//
//  SearchResponse.swift
//  MarvelMovie
//
//  Created by Da on 7/27/18.
//  Copyright © 2018 MarvelMovie. All rights reserved.
//

import Foundation
import ObjectMapper

class SearchResponse : Mappable {
    
    var totalCount: Int?
    
    required init(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        totalCount <- map["total_count"]

    }
}
