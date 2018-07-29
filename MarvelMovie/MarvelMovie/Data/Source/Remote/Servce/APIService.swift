//
//  APIService.swift
//  MarvelMovie
//
//  Created by Da on 7/27/18.
//  Copyright © 2018 MarvelMovie. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

struct APIService {
    
    static let share = APIService()
    
    private var alamofireManager = Alamofire.SessionManager.default
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        alamofireManager = Alamofire.SessionManager(configuration: configuration)
        alamofireManager.adapter = CustomRequestAdapter()
    }
    
    func request<T: Mappable>(input: BaseRequest, completion: @escaping (_ value: T?,_ error: BaseError? ) -> Void ) {
        
        alamofireManager.request(input.url, method: input.requestType, parameters: input.body, encoding: input.encoding)
            .validate(statusCode: 200..<500)
            .responseJSON { response in
                print(response.request?.url ?? "Error")
                print(response)
                switch response.result {
                case .success(let value):
                    if let statusCode = response.response?.statusCode {
                        if statusCode == 200 {
                            let object = Mapper<T>().map(JSONObject: value)
                            completion(object, nil)
                        } else {
                            if let error = Mapper<ErrorResponse>().map(JSONObject: value) {
                                completion(nil, BaseError.apiFailure(error: error))
                            } else {
                                completion(nil, BaseError.httpError(httpCode: statusCode))
                            }
                        }
                    } else {
                        completion(nil, BaseError.unexpectedError)
                    }
                    break
                case .failure(let error):
                    completion(nil, error as? BaseError)
                    break
                }
        }
    }
}
