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
    @IBOutlet private weak var nameScreen: UILabel!
    @IBOutlet private weak var favoriteTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setup()
        getData()
    }
    
    private func setupUI() {
        let lineView = UIView()
        lineView.backgroundColor = ColorConstant.lineColor
        lineView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lineView)
        lineView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        lineView.topAnchor.constraint(equalTo: nameScreen.bottomAnchor).isActive = true
        lineView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    private func setup() {
        self.favoriteTableView.delegate = self
        self.favoriteTableView.dataSource = self
        self.favoriteTableView.register(cellType: FavoriteTableViewCell.self)
    }
    
    private func getData() {
        favoriteListMovies = HandlingMoviesDatabase.shared.fetchMovie()
        favoriteTableView.reloadData()
    }
}

extension LibraryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteListMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favoriteTableView.dequeueReusableCell(for: indexPath, cellType: FavoriteTableViewCell.self)
        cell.setupCell(movie: favoriteListMovies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height / 3 - cellConstaintSize.minus2HeightTable
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
}
