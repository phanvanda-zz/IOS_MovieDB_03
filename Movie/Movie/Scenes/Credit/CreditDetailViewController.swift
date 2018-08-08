//
//  CreditDetailViewController.swift
//  Movie
//
//  Created by Da on 8/6/18.
//  Copyright © 2018 Tran Cuong. All rights reserved.
//

import UIKit
import Reusable

class CreditDetailViewController: UIViewController, NibReusable {
    //MAKR: OUTLET
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var titleView: UIView!
    @IBOutlet private weak var infoView: UIView!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var genderLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var placeBirthLabel: UILabel!
    @IBOutlet private weak var knowLedgeLabel: UILabel!
    @IBOutlet private weak var biographyLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    
    //MARK: VARIABLE
    var credit: Credit?
    var movies = [Movie]()
    
    private struct Constant {
        static let placeBirthString = "Place birth: "
        static let dateBirthString = "Date: "
        static let womanString = "Gender: Woman"
        static let manString = "Gender: Man"
        static let heighCellRatioSize: CGFloat = 0.25
        static let widthBorderSize: CGFloat = 1
        static let whiteColor = UIColor.white.cgColor
        static let loadString = "Loading ... "
    }
    
    
    private let creditDetailRepository: CreditDetailRepository = CreditDetailRepositoryImpl(api: APIService.share)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.showHud(Constant.loadString)
        loadData()
        loadWithApi()
    }
    
    private func setup() {
        tableView.register(cellType: CreditDetailTableViewCell.self)
        setupUILine(view: titleView)
    }
    
    private func loadData(){
        guard let name = credit?.name,
            let gender = credit?.gender,
            let poster = credit?.profilePath,
            let knowLedge = credit?.knownForDepartment,
            let url = URL(string: URLs.posterImage + poster) else {
                return
        }
        avatarImageView.sd_setImage(with: url, completed: nil)
        nameLabel.text = name
        titleLabel.text = knowLedge
        genderLabel.text = gender == 1 ? Constant.womanString : Constant.manString
    }
    
    private func loadWithApi() {
        showHud(Constant.loadString)
        guard let id = credit?.id else { return }
        creditDetailRepository.getDetailPerson(id: id) { [weak self] (resultPerson) in
            guard let `self` = self else { return }
            self.hideHUD()
            switch resultPerson {
            case .success(let personRespone):
                guard let biography = personRespone?.biography,
                    let knownForDepartment = personRespone?.knownForDepartment,
                    let placeOfBirth = personRespone?.placeOfBirth,
                    let birthday = personRespone?.birthday else { return }
                self.titleLabel.text = knownForDepartment
                self.biographyLabel.text = biography
                self.placeBirthLabel.text = Constant.placeBirthString + placeOfBirth
                self.dateLabel.text = Constant.dateBirthString + birthday
            case .failure( _):
                print("ERROR CREDIT")
            }
        }
        creditDetailRepository.getMovies(id: id) { [weak self] (resultCredits) in
            guard let `self` = self else { return }   
            switch resultCredits {
            case .success(let creditRespone):
                guard let movies = creditRespone?.movies
                    else { return }
                self.movies = movies
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.hideHUD()
                }
            case .failure( _):
                print("ERROR CREDIT")
            }
        }
    }
    
    func pushMovieDetail(movie: Movie) {
        let movieVC = MovieDetailViewController.instantiate()
        movieVC.movie = movie
        present(movieVC, animated: true, completion: nil)
    }
    
    @IBAction func backTappedButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension CreditDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CreditDetailTableViewCell.self) as CreditDetailTableViewCell
        let movie = movies[indexPath.row]
        cell.updateCell(movie: movie)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height * Constant.heighCellRatioSize
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CreditDetailTableViewCell,
            let movie = cell.movie
            else { return }
        pushMovieDetail(movie: movie)
    }
}
