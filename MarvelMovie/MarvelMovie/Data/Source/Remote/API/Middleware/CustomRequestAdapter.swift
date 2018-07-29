//
//  CustomRequestAdapter.swift
//  MarvelMovie
//
//  Created by Da on 7/27/18.
//  Copyright © 2018 MarvelMovie. All rights reserved.
//

import Foundation
import Alamofire

class CustomRequestAdapter: RequestAdapter {
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return urlRequest
    }
}
