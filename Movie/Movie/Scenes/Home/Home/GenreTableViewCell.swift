//
//  GenreTableViewCell.swift
//  Movie
//
//  Created by Da on 7/31/18.
//  Copyright © 2018 Tran Cuong. All rights reserved.
//

import UIKit
import Reusable

protocol TableViewDelegate: class {
    func loadmoreAction(name: String, movies: [Movie])
    func pushMovieDetail(movie: Movie)
}

class GenreTableViewCell: UITableViewCell, NibReusable {
    
    // MARK: OUTLET
    @IBOutlet private weak var name_Genre_Label: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var loadMoreButton: UIButton!
    
    // MARK: VARIABLES
    private var movies = [Movie]()
    private var name = ""
    weak var delegate: TableViewDelegate?
    private let moviesListRepository: MovieRepository = MovieRepositoryImpl(api: APIService.share)
    
    func updateCell(name: String?, movies: [Movie]?) {
        guard let movies = movies, let name = name else {
            return
        }
        name_Genre_Label.text = name
        self.name = name
        self.movies = movies
        self.collectionView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    @IBAction func loadmoreActionButton(_ sender: Any) {
        delegate?.loadmoreAction(name: name, movies: movies)
    }
    
    func setup() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(cellType: MovieCollectionViewCell.self)
    }
}

extension GenreTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MovieCollectionViewCell.self)
        cell.updateCell(movie: movies[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width) / 4 + 6 * cellConstaintSize.spaceCollectionCell , height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellConstaintSize.spaceCollectionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? MovieCollectionViewCell,
        let movie = cell.movie else {
            return
        }
        delegate?.pushMovieDetail(movie: movie)
    }
}
