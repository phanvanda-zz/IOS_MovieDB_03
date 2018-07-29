//
//  ErrorResponse.swift
//  MarvelMovie
//
//  Created by Da on 7/27/18.
//  Copyright © 2018 MarvelMovie. All rights reserved.
//

import Foundation
import Foundation
import ObjectMapper

class ErrorResponse: Mappable {
    
    var message: String?
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        
        message <- map["status_message"]
    }
}
