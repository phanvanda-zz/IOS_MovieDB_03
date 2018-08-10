//
//  TopFilmTableViewCell.swift
//  Movie
//
//  Created by TranCuong on 8/1/18.
//  Copyright © 2018 Tran Cuong. All rights reserved.
//

import UIKit
import Reusable

protocol TopTableViewDelegate: class {
    func loadmoreAction(url: String,name: String)
    func pushMovieDetail(movie: Movie)
}

class TopFilmTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var movies = [Movie]()
    var name = ""
    var url = ""
    weak var delegate: TopTableViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    func setup() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(cellType: MovieCollectionViewCell.self)
    }
    
    func updateCell(movies: [Movie]?,namelbl:String, url: String) {
        guard let movies = movies else { return }
        self.movies = movies
        self.nameLabel.text = namelbl
        self.url = url
        self.collectionView.reloadData()
        name = namelbl
    }
    
    @IBAction func loadmoreActionButton(_ sender: Any) {
        delegate?.loadmoreAction(url: self.url,name: self.name)
    }
}

extension TopFilmTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MovieCollectionViewCell.self) as? MovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.updateCell(movie: movies[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width) / 3 - sizeCollectionView.spaceItem , height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? MovieCollectionViewCell,
            let movie = cell.movie else {
                return
        }
        delegate?.pushMovieDetail(movie: movie)
    }
}
