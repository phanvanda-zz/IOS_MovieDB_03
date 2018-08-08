//
//  HomeViewController.swift
//  Movie
//
//  Created by Da on 7/31/18.
//  Copyright © 2018 Tran Cuong. All rights reserved.
//

import UIKit
import iCarousel

class HomeViewController: UIViewController {
    // MARK: OUTLET
    @IBOutlet private weak var carouView: iCarousel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var titleScreenLabel: UILabel!
    @IBOutlet private weak var titleView: UIView!
    
    // MARK: VARIABLES
    var genres = [Genre]()
    var moviesDic = [String : [Movie]]()
    var moviesShow = [Movie]()
    var timer = Timer()
    private let homeRepository: HomeRepository = HomeRepositoryImpl(api: APIService.share)
    private let movieRepository: MovieRepository = MovieRepositoryImpl(api: APIService.share)
    
    private struct Constant {
        static let spaceCollectionCell = CGFloat(8)
        static let heightTableCell = CGFloat(24)
        static let spaceItem = CGFloat(0)
        static let spaceLine = CGFloat(0)
        static let ratio: CGFloat = 0.7
        static let ratioWidthViewCarousel: CGFloat = 0.9
        static let ratioHeighViewCarousel: CGFloat = 0.9
        static let ratioBotViewCarousel: CGFloat = 0.2
        static let heighTitleLabel: CGFloat = 20
        static let colorBotView = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 0.6)
        static let colorViewCarousel = UIColor.black
        static let colorTitle = UIColor.white
        static let timeWait: Double = 3.0
        static let timeScroll: Double = 1.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUILine(view: titleView)
        tableView.register(cellType: GenreTableViewCell.self)
        setupUI()
        loadData()
        loadDataTopRate()
    }
    
    private func setupUI() {
        timer = Timer.scheduledTimer(timeInterval: Constant.timeWait, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        carouView.type = .cylinder
    }
   
    private func loadData() {
        showHud(ConstantString.loadStr)
        homeRepository.getGenres { [weak self] (resultGenres) in
            guard let `self` = self else { return }
            self.hideHUD()
            switch resultGenres {
            case .success(let genreRespone):
                guard let result = genreRespone?.genres else { return }
                for item in result {
                    self.homeRepository.getMovies(id: item.id, page: 1) { (resultMoveList) in
                        switch resultMoveList {
                        case .success(let moviesListRespone):
                            guard let id = moviesListRespone?.id,
                                let movies = moviesListRespone?.movies else { return }
                            self.moviesDic[String(id)] = movies
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        case .failure(let error):
                            print("ERROR MOVIESLIST  \(error.debugDescription.description)")
                        }
                    }
                }
                self.genres = result
            case .failure(let error):
                print("ERROR GENRES \(error.debugDescription.description)")
            }
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genres.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height * Constant.ratio
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: GenreTableViewCell.self) as GenreTableViewCell
        let item = genres[indexPath.row]
        let name = item.name
        let idStr = String(item.id)
        let movies = moviesDic[idStr]
        cell.updateCell(name: name, movies: movies)
        cell.delegate = self
        return cell
    }
}

extension HomeViewController: TableViewDelegate {
    func pushMovieDetail(movie: Movie) {
        let vc = MovieDetailViewController.instantiate()
        vc.movie = movie
        present(vc, animated: true, completion: nil)
    }
    
    func loadmoreAction(name: String, movies: [Movie]) {
        let vc = LoadMoreViewController.instantiate()
        vc.reloadData(name: name, movies: movies)
        present(vc, animated: true, completion: nil)
    }
}

extension HomeViewController: iCarouselDelegate, iCarouselDataSource {
    func loadDataTopRate() {
        self.movieRepository.getTopMoviesList() {
            [weak self] (resultList) in
            guard let `self` = self else { return }
            switch resultList {
            case .success(let moviesTopListResponse):
                guard let movies = moviesTopListResponse?.movies else { return }
                self.moviesShow = movies
                DispatchQueue.main.async {
                    self.carouView.reloadData()
                }
            case .failure( _):
                print("Error")
            }
        }
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return moviesShow.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let view = UIView(frame: CGRect(x: 0,
                                        y: 0,
                                        width: carouView.frame.width * Constant.ratioWidthViewCarousel,
                                        height: carouView.frame.height * Constant.ratioHeighViewCarousel))
        let imageView = UIImageView(frame: CGRect(
            x: 0,
            y: 0,
            width: view.frame.width,
            height: view.frame.height))
        let botView = UIView(frame: CGRect(
            x: 0,
            y: imageView.frame.height * (1 - Constant.ratioBotViewCarousel),
            width: view.frame.width,
            height: view.frame.height * Constant.ratioBotViewCarousel))
        let titleLable = UILabel(frame: CGRect(
            x: 0,
            y: imageView.bounds.height - Constant.heighTitleLabel,
            width: botView.frame.width,
            height: Constant.heighTitleLabel))
        view.backgroundColor = Constant.colorViewCarousel
        botView.backgroundColor = Constant.colorBotView
        titleLable.textColor = Constant.colorTitle
        titleLable.contentMode = .center
        view.addSubview(imageView)
        view.addSubview(botView)
        view.addSubview(titleLable)
        let item = moviesShow[index]
        let url = URL(string: URLs.backdropImage + item.backdropPath)
        imageView.sd_setImage(with: url, completed: nil)
        titleLable.text = item.title
        return view
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        switch option {
        case .wrap:
            return 1
        case .spacing:
            return value * 1.1
        default:
            return value
        }
    }
    
    @objc func timerAction() {
        carouView.scrollToItem(at: carouView.currentItemIndex + 1, duration: Constant.timeScroll)
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        pushMovieDetail(movie: moviesShow[index])
    }
}
