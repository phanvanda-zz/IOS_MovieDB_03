//
//  Genre.swift
//  Movie
//
//  Created by Da on 7/31/18.
//  Copyright © 2018 Tran Cuong. All rights reserved.
//
import Foundation
import ObjectMapper

class Genre: BaseModel {
    var id = 0
    var name = ""
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    init() {}
}
