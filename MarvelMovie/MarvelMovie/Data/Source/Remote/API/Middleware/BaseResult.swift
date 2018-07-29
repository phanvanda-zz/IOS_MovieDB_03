//
//  BaseResult.swift
//  MarvelMovie
//
//  Created by Da on 7/27/18.
//  Copyright © 2018 MarvelMovie. All rights reserved.
//

import Foundation
import ObjectMapper

enum BaseResult<T: Mappable> {
    case success(T?)
    case failure(error: BaseError?)
}
