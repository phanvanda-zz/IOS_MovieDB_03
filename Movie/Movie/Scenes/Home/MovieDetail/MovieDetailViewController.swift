import UIKit
import SDWebImage
import Reusable
import Cosmos
import youtube_ios_player_helper
import StatusBarNotifications

final class MovieDetailViewController: UIViewController, StoryboardSceneBased {
    private struct Constant {
        static let ratio: CGFloat = 1 / 2
        static let actorStr = "ACTOR"
        static let crewStr = "CREW"
        static let heightMore: CGFloat = 24
        static let sectionTable = 2
        static let rowTable = 1
        static let heighLabel: CGFloat = 40
    }
    
    private enum tagCollectionView: Int {
        case actor = 1
        case crew = 2
    }
    
    // MARK: OUTLET
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var titleScreenLabel: UILabel!
    @IBOutlet private weak var titleView: UIView!
    @IBOutlet private weak var infoView: UIView!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleMovie: UILabel!
    @IBOutlet private weak var cosmosView: CosmosView!
    @IBOutlet private weak var voteLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var popularLabel: UILabel!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var youtubeImageView: UIImageView!
    
    // MARK: reviewTrailerView
    @IBOutlet private weak var heightConstraintView: NSLayoutConstraint!
    @IBOutlet private weak var heightReviewView: NSLayoutConstraint!
    @IBOutlet private weak var reviewTrailerView: UIView!
    @IBOutlet private weak var reviewLabel: UILabel!
    @IBOutlet private weak var youtubePlayer: YTPlayerView!
    @IBOutlet private weak var seeMoreButton: UIButton!
    
    // MARK: Credit
    @IBOutlet private weak var tableView: UITableView!
    
    //MARK: VARIABLES
    var movie: Movie?
    var actors = [Credit]()
    var crews = [Credit]()
    var keys = [KeyTrailer]()
    var seemore = true
    var flag = false
    var heighLabel: CGFloat = 0
    private let moviesRepository: MovieRepository = MovieRepositoryImpl(api: APIService.share)
    static var sceneStoryboard = UIStoryboard(name: Storyboard.home, bundle: nil)
    //MARK: FUNCION
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        loadData()
    }
    
    @IBAction func swipBack(_ sender: Any) {
        dismissDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupLike()
    }
    
    private func setup() {
        tableView.register(cellType: CreditTableViewCell.self)
        setupUILine(view: titleView)
    }
    
    private func loadData() {
        guard let poster = movie?.posterPath,
            let title = movie?.title,
            let url = URL(string: URLs.posterImage + poster),
            let vote = movie?.vote,
            let overview = movie?.overview,
            let releaseDate = movie?.releaseDate,
            let popular = movie?.popularity
            else { return }
        titleScreenLabel.text = title
        titleMovie.text = title
        posterImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "not_found"), options: .allowInvalidSSLCertificates, completed: nil)
        cosmosView.rating = vote / 2
        voteLabel.text = "( " + String(vote) + " )"
        dateLabel.text = "Release date: " + releaseDate 
        popularLabel.text = "Popularity: " + String(popular)
        reviewLabel.text = overview
        heighLabel = getHeighLabel()
        loadWithApi()
    }
    
    private func loadWithApi() {
        showHud(ConstantString.loadStr)
        guard let id = movie?.id else { return }
        moviesRepository.getKeyTrailer(id: id) {
            [weak self] (resultKeys) in
            guard let `self` = self else { return }
            switch resultKeys {
            case .success(let keyRespone):
                guard let keys = keyRespone?.keyTrailers else { return }
                self.keys = keys
                DispatchQueue.main.async {
                    self.getTrailer()
                }
            case .failure(let error):
                print("ERROR KEY \(error.debugDescription.description)")
            }
        }
        moviesRepository.getCredit(id: id) { [weak self] (resultCredits) in
            guard let `self` = self else { return }
            self.hideHUD()
            switch resultCredits {
            case .success(let creditRespone):
                guard let casts = creditRespone?.casts, let crews = creditRespone?.crews
                    else { return }
                self.actors = casts
                self.crews = crews
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.hideHUD()
                }
            case .failure(let error):
                print("ERROR CREDIT \(error.debugDescription.description)")
            }
        }
    }
    
    private func getTrailer() {
        guard let key = keys.first?.key else { return }
        youtubePlayer.load(withVideoId: key)
        youtubeImageView.isHidden = true
    }
    
    private func pushCreditDetail(credit: Credit?) {
        guard let creditDetailVC = CreditDetailViewController(nibName: IdentifierScreen.credit, bundle: nil) as? CreditDetailViewController else {
            return
        }
        creditDetailVC.credit = credit
        present(creditDetailVC, animated: true, completion: nil)
    }
    
    func getHeighLabel() -> CGFloat {
        guard let height = reviewLabel.text?.height(withConstrainedWidth: reviewLabel.frame.width, font: UIFont.systemFont(ofSize: 15)) else { return Constant.heighLabel }
        return height
    }
    
    //MARK: ACTION
    @IBAction private func seeMoreTappedButton(_ sender: Any) {
        if seemore {
            heightConstraintView.constant = heighLabel
            seeMoreButton.setTitle(ConstantString.hide, for: .normal)
        } else {
            heightConstraintView.constant = Constant.heighLabel
            seeMoreButton.setTitle(ConstantString.seemore, for: .normal)
        }
        seemore = !seemore
    }
    
    @IBAction private func backTappedButton(_ sender: Any) {
        dismissDetail()
    }
    
    @IBAction func likeTappedButton(_ sender: Any) {
        checkLike()
    }
    
    private func setupLike() {
        guard let movieLike = movie else {
            return
        }
        guard let _ = HandlingMoviesDatabase.shared.checkData(movie: movieLike) else {
            likeButton.setImage(#imageLiteral(resourceName: "like_no"), for: .normal)
            flag = false
            return
        }
        likeButton.setImage(#imageLiteral(resourceName: "like_yes"), for: .normal)
        flag = true
    }
    
    private func checkLike() {
        guard let movieLike = movie else {
            return
        }
        if (!flag) {
            flag = !flag
            let _ = HandlingMoviesDatabase.shared.insertMovie(movie: movieLike)
            likeButton.setImage(#imageLiteral(resourceName: "like_yes"), for: .normal)
            StatusBarNotifications.show(withText: ConstantString.added,
                                        animation: .slideFromTop,
                                        backgroundColor: .black,
                                        textColor: ColorConstant.textNoti)
        } else {
            let _ = HandlingMoviesDatabase.shared.deteleMovie(movie: movieLike)
            flag = !flag
            likeButton.setImage(#imageLiteral(resourceName: "like_no"), for: .normal)
            StatusBarNotifications.show(withText: ConstantString.removed,
                                        animation: .slideFromTop,
                                        backgroundColor: .black,
                                        textColor: ColorConstant.textNoti)
        }
    }
}

extension MovieDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constant.sectionTable
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constant.rowTable
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CreditTableViewCell.self) as CreditTableViewCell
        indexPath.section == 0 ? cell.setContentForCell(data: actors, title: Constant.actorStr) :
            cell.setContentForCell(data: crews, title: Constant.crewStr)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sizeTableView.heighTableViewCell + 16
    }
}

extension MovieDetailViewController: pushCreditTableViewDelegate {
    func pushCreditDetail(credit: Credit) {
        let vc = CreditDetailViewController(nibName: IdentifierScreen.credit, bundle: nil)
        vc.credit = credit
        presentDetail(vc)
    }
}
