//
//  UserRepository.swift
//  Movie
//
//  Created by Da on 7/31/18.
//  Copyright © 2018 Tran Cuong. All rights reserved.
//

import Foundation
import ObjectMapper

protocol HomeRepository {
    func getGenres(completion: @escaping completionGenres)
    func getMovies(id: Int?, completion: @escaping completionMovies)
}

typealias completionGenres = (BaseResult<GenreResponse>) -> Void
//typealias completionMovies = (BaseResult<MoviesListResponse>) -> Void

class HomeRepositoryImpl: HomeRepository {
    private var api: APIService?
    
    required init(api: APIService) {
        self.api = api
    }
    
    static let sharedInstance: HomeRepository = HomeRepositoryImpl(api: APIService.share)
    
    func getGenres(completion: @escaping completionGenres) {
        let input = GetGenresRequest()
        guard let api = api else {
            return
        }
        api.request(input: input) { (object: GenreResponse?, error) in
            guard let object = object else {
                guard let error = error else {
                    return completion(.failure(error: nil))
                }
                return completion(.failure(error: error))
            }
            completion(.success(object))
        }
    }
    
    func getMovies(id: Int?, completion: @escaping completionMovies) {
        guard let id = id,
            let api = api else {
            return
        }
        let input = GetMoviesRequest(id: id)
        api.request(input: input) { (object: MoviesListResponse?, error) in
            guard let object = object else {
                guard let error = error else {
                    return completion(.failure(error: nil))
                }
                return completion(.failure(error: error))
            }
            completion(.success(object))
        }
    }
}
