
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
    var name = ""
    
    static let sceneStoryboard = UIStoryboard(name: Storyboard.home, bundle: nil)
    
    private struct Constant {
        static let spaceItem = CGFloat(0)
        static let spaceLine = CGFloat(0)
        static let ratioWidth: CGFloat = 1 / 3
        static let ratioHeigh: CGFloat = 1 / 3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        collectionView.register(cellType: MovieCollectionViewCell.self)
        backButton.imageView?.contentMode = .scaleAspectFit
        setupUILine(view: titleView)
        titleScreenLabel.text = name
    }
    
    func reloadData(name: String, movies: [Movie]) {
        self.movies = movies
        self.name = name
    }
    
    @IBAction func backHomeTappedButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func pushMovieDetail(movie: Movie) {
        guard let movieDetailVC = self.storyboard?.instantiateViewController(withIdentifier: IdentifierScreen.movieDetail) as? MovieDetailViewController else {
            return
        }
        movieDetailVC.movie = movie
        present(movieDetailVC, animated: true, completion: nil)
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
        return CGSize(width: (collectionView.frame.width) * Constant.ratioWidth, height: collectionView.frame.height * Constant.ratioHeigh)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constant.spaceItem
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constant.spaceLine
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? MovieCollectionViewCell,
            let movie = cell.movie
            else { return }
        pushMovieDetail(movie: movie)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let lastElement = movies.count - 1
        if indexPath.row == lastElement {
            
        }
    }
}
