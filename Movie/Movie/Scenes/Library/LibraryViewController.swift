//
//  LibraryViewController.swift
//  Movie
//
//  Created by Da on 7/31/18.
//  Copyright © 2018 Tran Cuong. All rights reserved.
//

import UIKit
import Reusable
import StatusBarNotifications

class LibraryViewController: UIViewController, NibReusable {
    var favoriteListMovies = [Movie]()
    @IBOutlet private weak var favoriteTableView: UITableView!
    @IBOutlet private weak var topView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getData()
        setupUILine(view: topView)
    }
    
    private func setup() {
        self.favoriteTableView.delegate = self
        self.favoriteTableView.dataSource = self
        self.favoriteTableView.register(cellType: FavoriteTableViewCell.self)
    }
    
    private func setupLine(view: UIView) {
        let lineView = UIView()
        lineView.backgroundColor = ColorConstant.lineColor
        lineView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lineView)
        
        lineView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        lineView.topAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        lineView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    private func getData() {
        favoriteListMovies = HandlingMoviesDatabase.shared.fetchMovie()
        favoriteTableView.reloadData()
    }
    
    func pushMovieDetail(movie: Movie) {
        let vc = MovieDetailViewController.instantiate()
        vc.movie = movie
        present(vc, animated: true, completion: nil)
    }
}

extension LibraryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteListMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favoriteTableView.dequeueReusableCell(for: indexPath, cellType: FavoriteTableViewCell.self)
        cell.setupCell(movie: favoriteListMovies[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sizeTableView.heighTableViewCell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            if HandlingMoviesDatabase.shared.deteleMovie(movie: favoriteListMovies[indexPath.row]) {
                self.favoriteListMovies.remove(at: indexPath.row)
                self.favoriteTableView.deleteRows(at: [indexPath], with: .automatic)
                StatusBarNotifications.show(withText: "The movie has been removed from the favorites list", animation: .slideFromTop, backgroundColor: .black, textColor: ColorConstant.textNoti)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? FavoriteTableViewCell,
            let movie = cell.movie
            else { return }
        pushMovieDetail(movie: movie)
    }
}
