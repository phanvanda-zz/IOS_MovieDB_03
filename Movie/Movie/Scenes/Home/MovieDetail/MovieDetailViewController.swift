import UIKit
import SDWebImage
import Reusable
import Cosmos
import youtube_ios_player_helper

final class MovieDetailViewController: UIViewController, StoryboardSceneBased {
    private struct Constant {
        static let spaceItem = CGFloat(0)
        static let spaceLine = CGFloat(0)
        static let ratio: CGFloat = 1 / 2
        static let actorStr = "ACTOR"
        static let crewStr = "CREW"
        static let heightMore: CGFloat = 24
        static let loading = "Loading..."
        static let sectionTable = 2
        static let rowTable = 1
    }
    
    private enum tagCollectionView: Int {
        case actor = 1
        case crew = 2
    }
    
    // MARK: OUTLET
    @IBOutlet private weak var titleView: UIView!
    @IBOutlet private weak var infoView: UIView!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleMovie: UILabel!
    @IBOutlet private weak var cosmosView: CosmosView!
    @IBOutlet private weak var voteLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var popularLabel: UILabel!
    
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
    private let moviesRepository: MovieRepository = MovieRepositoryImpl(api: APIService.share)
    static var sceneStoryboard = UIStoryboard(name: Storyboard.home, bundle: nil)
    
    //MARK: FUNCION
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        loadData()
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
        titleMovie.text = title
        posterImageView.sd_setImage(with: url, completed: nil)
        cosmosView.rating = vote / 2
        voteLabel.text = "( " + String(vote) + " )"
        dateLabel.text = "Release date: " + releaseDate 
        popularLabel.text = "Popularity: " + String(popular)
        reviewLabel.text = overview
        loadWithApi()
    }
    
    private func loadWithApi() {
        showHud(Constant.loading)
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
    }
    
    private func pushCreditDetail(credit: Credit?) {
        guard let creditDetailVC = CreditDetailViewController(nibName: IdentifierScreen.credit, bundle: nil) as? CreditDetailViewController else {
            return
        }
        creditDetailVC.credit = credit
        present(creditDetailVC, animated: true, completion: nil)
    }
    
    //MARK: ACTION
    @IBAction private func seeMoreTappedButton(_ sender: Any) {
        guard let height = reviewLabel.text?.height(withConstrainedWidth: reviewLabel.frame.width, font: UIFont.systemFont(ofSize: 17)) else { return }
        heightConstraintView.constant = height
        heightReviewView.constant = heightReviewView.constant + height
        seeMoreButton.isHidden = true
        youtubePlayer.topAnchor.constraint(equalTo: reviewLabel.bottomAnchor).isActive = true
    }
    
    @IBAction private func backTappedButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
        return infoView.frame.height + Constant.heightMore
    }
}

extension MovieDetailViewController: pushCreditTableViewDelegate {
    func pushCreditDetail(credit: Credit) {
        let vc = CreditDetailViewController(nibName: IdentifierScreen.credit, bundle: nil)
        vc.credit = credit
        present(vc, animated: true, completion: nil)
    }
}
