//
//  UserRepository.swift
//  MarvelMovie
//
//  Created by Da on 7/27/18.
//  Copyright © 2018 MarvelMovie. All rights reserved.
//

import Foundation
import ObjectMapper

protocol UserRepository {
    func searchUsers(keyword: String, limit: Int, completion: @escaping (BaseResult<SearchResponse>) -> Void)
    func getGenres(completion: @escaping (BaseResult<GenreResponse>) -> Void)
    func getMoviesByGenres(id: Int, completion: @escaping (BaseResult<MoviesByGenresResponse>) -> Void)
}

class UserRepositoryImpl: UserRepository {
    
    private var api: APIService?
    
    required init(api: APIService) {
        self.api = api
    }
    
    func searchUsers(keyword: String, limit: Int, completion: @escaping (BaseResult<SearchResponse>) -> Void) {
        let input = SearchRequest(keyword: keyword, limit: limit)
        
        api?.request(input: input) { (object: SearchResponse?, error) in
            if let object = object {
                completion(.success(object))
            } else if let error = error {
                completion(.failure(error: error))
            } else {
                completion(.failure(error: nil))
            }
        }
    }
    
    func getGenres(completion: @escaping (BaseResult<GenreResponse>) -> Void) {
        let input = GetGenresRequest(url: URLs.APIGetGenresUrl)
        api?.request(input: input) { (object: GenreResponse?, error) in
            if let object = object {
                completion(.success(object))
            } else if let error = error {
                completion(.failure(error: error))
            } else {
                completion(.failure(error: nil))
            }
        }
    }
    
    func getMoviesByGenres(id: Int, completion: @escaping (BaseResult<MoviesByGenresResponse>) -> Void) {
        let input = GetMoviesByGenresRequest(id: id)
        api?.request(input: input) { (object: MoviesByGenresResponse?, error) in
            if let object = object {
                completion(.success(object))
            } else if let error = error {
                completion(.failure(error: error))
            } else {
                completion(.failure(error: nil))
            }
        }
    }
}

