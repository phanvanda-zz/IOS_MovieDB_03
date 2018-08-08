//
//  TopFilmTableViewCell.swift
//  Movie
//
//  Created by TranCuong on 8/1/18.
//  Copyright © 2018 Tran Cuong. All rights reserved.
//

import UIKit
import Reusable

class TopFilmTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var movies = [Movie]()
    var name = ""
    weak var delegate: TableViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    func setup() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(cellType: MovieCollectionViewCell.self)
    }
    
    func updateCell(movies: [Movie]?,namelbl:String) {
        guard let movies = movies else { return }
        self.movies = movies
        self.nameLabel.text = namelbl
        self.collectionView.reloadData()
        name = namelbl
    }
    
    @IBAction func loadmoreActionButton(_ sender: Any) {
        delegate?.loadmoreAction(name: name, movies: movies)
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
        return CGSize(width: (collectionView.frame.width) / 4 + 6 * cellConstaintSize.spaceCollectionCell , height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? MovieCollectionViewCell,
            let movie = cell.movie else {
                return
        }
        delegate?.pushMovieDetail(movie: movie)
    }
}
