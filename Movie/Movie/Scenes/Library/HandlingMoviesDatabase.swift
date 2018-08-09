//
//  HandlingMoviesDatabase.swift
//  Movie
//
//  Created by TranCuong on 8/7/18.
//  Copyright © 2018 Tran Cuong. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class HandlingMoviesDatabase {
    static let shared = HandlingMoviesDatabase()
    
    private func getManagerContext() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        return managedContext
    }
    
    func insertMovie(movie: Movie) -> Bool {
        if (checkData(movie: movie) == nil) {
            do {
                guard let managedContext = getManagerContext(),
                      let movieEntity = NSEntityDescription.entity(forEntityName: nameDatabase.movieDatabase, in: managedContext) else {
                    return false
                }
                let movieObject = NSManagedObject(entity: movieEntity, insertInto: getManagerContext())
                movieObject.setValue(movie.id, forKey: MovieInfoDB.movieId)
                movieObject.setValue(movie.title, forKey: MovieInfoDB.title)
                movieObject.setValue(movie.overview, forKey: MovieInfoDB.overview)
                movieObject.setValue(movie.posterPath, forKey: MovieInfoDB.posterPath)
                print(movieObject)
                try managedContext.save()
                return true
            } catch {
                return false
            }
        }
        return false
    }
    
    func checkData(movie: Movie) -> NSManagedObject? {
        let managedContext = getManagerContext()
        guard let managedContextTmp = managedContext else {
            return nil
        }
        let request = NSFetchRequest<NSManagedObject>(entityName: nameDatabase.movieDatabase)
        var tmpFetch = [NSManagedObject]()
        do {
            tmpFetch = try managedContextTmp.fetch(request)
            for i in tmpFetch {
                let movieIdFetch = i.value(forKey: MovieInfoDB.movieId) as? Int ?? 0
                if movieIdFetch == movie.id {
                    print(i)
                    return i
                }
            }
        } catch {
            return nil
        }
        return nil
    }
    
    func fetchMovie() -> [Movie] {
        let managedContext = getManagerContext()
        var tmpMovies = [Movie]()
        let request = NSFetchRequest<NSManagedObject>(entityName: nameDatabase.movieDatabase)
        var tmpFetch = [NSManagedObject]()
        if let tmpManagedContext = managedContext {
            do {
                tmpFetch = try tmpManagedContext.fetch(request)
                for i in tmpFetch {
                    let tmpMovieId = i.value(forKey: MovieInfoDB.movieId) as? Int ?? 0
                    let tmpTitleMovie = i.value(forKey: MovieInfoDB.title) as? String ?? ""
                    let tmpPosterPath = i.value(forKey: MovieInfoDB.posterPath) as? String ?? ""
                    let tmpOverview = i.value(forKey: MovieInfoDB.overview) as? String ?? ""
                    let tmpMovieData = Movie(movieId: tmpMovieId, title: tmpTitleMovie, posterPath: tmpPosterPath, overview: tmpOverview)
                    tmpMovies.append(tmpMovieData)
                }
            } catch {
            }
        }
        return tmpMovies
    }
    
    func cleanAllCoreData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: nameDatabase.movieDatabase)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        if let managedContext = getManagerContext() {
            do {
                try managedContext.execute(deleteRequest)
            } catch {
            }
        }
    }
    
    func deteleMovie(movie: Movie) -> Bool {
        if let tmpData = checkData(movie: movie), let managedContext = getManagerContext() {
            do {
                managedContext.delete(tmpData)
                try managedContext.save()
                return true
            } catch {
                return false
            }
        }
        return false
    }
}

