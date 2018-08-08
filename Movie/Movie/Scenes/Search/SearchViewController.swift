//
//  SreachViewController.swift
//  Movie
//
//  Created by Da on 7/31/18.
//  Copyright © 2018 Tran Cuong. All rights reserved.
//

import UIKit
import Reusable

class SearchViewController: UIViewController, NibReusable {
    @IBOutlet private weak var nameScreen: UILabel!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var movies = [Movie]()
    var currentMovieArray = [Movie]()
    var searchList = [String]()
    private let movieRepository: MovieRepository = MovieRepositoryImpl(api: APIService.share)
    var work = DispatchWorkItem {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setup()
    }
    
    private func setup() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(cellType: MovieCollectionViewCell.self)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        collectionView.isUserInteractionEnabled = false
        work.cancel()
        work = DispatchWorkItem {
            guard let text = searchBar.text else {
                self.movies.removeAll()
                self.collectionView.reloadData()
                return
            }
            self.movies.removeAll()
            self.collectionView.reloadData()
            self.loadData(query: text)
            self.collectionView.isUserInteractionEnabled = true
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: work)
    }
    
    private func loadData(query: String) {
        self.movieRepository.getSearchMoviesList(query: query, page: 1) { resultList in
            switch resultList {
            case .success(let moviesSearchListResponse):
                self.setData(moviesSearchByQueryResponse: moviesSearchListResponse)
            case .failure(let error):
                print(error?.errorMessage ?? "")
            }
        }
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.returnKeyType = .done
    }
    
    func setData(moviesSearchByQueryResponse: SearchMoviesResponse?) {
        guard let searchMoviesData = moviesSearchByQueryResponse?.movies else {
            return
        }
        self.movies = searchMoviesData
        for item in searchMoviesData {
            self.searchList.append(item.title)
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func pushMovieDetail(movie: Movie) {
        let vc = MovieDetailViewController.instantiate()
        vc.movie = movie
        self.present(vc, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.endEditing(true)
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: MovieCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath, cellType: MovieCollectionViewCell.self) as MovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.updateCell(movie: movies[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width) / 3, height: collectionView.frame.height / 2 -  cellConstaintSize.plusHeighCollection)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? MovieCollectionViewCell,
            let movie = cell.movie else {
                return
        }
        pushMovieDetail(movie: movie)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

