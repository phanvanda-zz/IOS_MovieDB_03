
//
//  LoadMoreViewController.swift
//  Movie
//
//  Created by Da on 8/2/18.
//  Copyright © 2018 Tran Cuong. All rights reserved.
//

import UIKit
import Reusable

final class LoadMoreViewController: UIViewController, StoryboardSceneBased {
    @IBOutlet private weak var titleScreenLabel: UILabel!
    @IBOutlet private weak var titleView: UIView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var backButton: UIButton!
    
    var movies = [Movie]()
    var genre = Genre()
    var page = 1
    var topMovieBool = true
    var url = ""
    static let sceneStoryboard = UIStoryboard(name: Storyboard.home, bundle: nil)
    private let homeRepository: HomeRepository = HomeRepositoryImpl(api: APIService.share)
    private let movieRepository: MovieRepository = MovieRepositoryImpl(api: APIService.share)
    private struct Constant {
        static let spaceItem = CGFloat(0)
        static let spaceLine = CGFloat(0)
        static let ratioWidth: CGFloat = 1 / 3
        static let ratioHeigh: CGFloat = 1 / 3
        static let heighTableViewCell: CGFloat = 160
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        collectionView.register(cellType: MovieCollectionViewCell.self)
        backButton.imageView?.contentMode = .scaleAspectFit
        setupUILine(view: titleView)
        titleScreenLabel.text = genre.name
    }
    
    func reloadData(genre: Genre) {
        self.genre = genre
        loadData(page: self.page)
        topMovieBool = false
        titleScreenLabel.text = genre.name
    }
    
    func reloadDataTopMovies(url: String, name: String) {
        self.url = url
        loadDataTopMovies(url: url, page: self.page)
        topMovieBool = true
        titleScreenLabel.text = name
    }
    
    func loadDataTopMovies(url: String, page: Int) {
        showHud(ConstantString.loadStr)
        movieRepository.getTopMoviesScreen(page: page, url: url) { [weak self] (resultMovies) in
            guard let `self` = self else { return }
            switch resultMovies {
            case .success(let moviesResponse):
                guard let movies = moviesResponse?.movies else { return }
                self.movies += movies
                if movies.count == 0 || movies.count < 10 {
                    return
                }
                print("movies.count \(movies.count)")
                print("page \(page)")
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.hideHUD()
                }
            case .failure(let error):
                print("ERROR MOVIESLIST  \(error.debugDescription.description)")
            }
        }
    }
    
    func loadData(page: Int) {
        showHud(ConstantString.loadStr)
        homeRepository.getMovies(id: genre.id, page: page) { [weak self] (resultMovies) in
            guard let `self` = self else { return }
            switch resultMovies {
            case .success(let moviesResponse):
                guard let movies = moviesResponse?.movies else { return }
                self.movies += movies
                if movies.count == 0 || movies.count < 10 {
                    return
                }
                print("movies.count \(movies.count)")
                print("page \(page)")
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.hideHUD()
                }
            case .failure(let error):
                print("ERROR MOVIESLIST  \(error.debugDescription.description)")
            }
        }
    }
    
    @IBAction func backHomeTappedButton(_ sender: Any) {
        dismissDetail()
    }
    
    @IBAction func scrollBack(_ sender: Any) {
        dismissDetail()
    }
    
    func pushMovieDetail(movie: Movie) {
        guard let movieDetailVC = self.storyboard?.instantiateViewController(withIdentifier: IdentifierScreen.movieDetail) as? MovieDetailViewController else {
            return
        }
        movieDetailVC.movie = movie
        presentDetail(movieDetailVC)
    }
}

extension LoadMoreViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MovieCollectionViewCell.self) as MovieCollectionViewCell
        cell.updateCell(movie: movies[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width) / 3 - sizeCollectionView.spaceItem, height: Constant.heighTableViewCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sizeCollectionView.spaceItem
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? MovieCollectionViewCell,
            let movie = cell.movie
            else { return }
        pushMovieDetail(movie: movie)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == movies.count - 1 {  
            let lastElement = movies.count - 1
            if indexPath.row == lastElement {
                self.page += 1
                _ = topMovieBool ? loadDataTopMovies(url: self.url, page: self.page) :  loadData(page: self.page)
            }
        }
    }
}
