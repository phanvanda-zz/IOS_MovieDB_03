import UIKit

class HomeTableViewCell: UITableViewCell, AlertViewController {

    @IBOutlet weak var genreNameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var movies: [Movie]?
    private let userRepository: UserRepository = UserRepositoryImpl(api: APIService.share)
    
    func updateCell(genre: Genre?, list_id_movies: Int?) {
        genreNameLabel.text = genre?.name
        if list_id_movies == 12 {
            
        }
        guard let  list_id = list_id_movies else { return }
        userRepository.getMoviesByGenres(id: list_id) { (result) in
            switch result {
            case .success(let movieseRespone):
                self.movies = movieseRespone?.movies
                self.collectionView.reloadData()
            case .failure(let error):
                print(error?.errorMessage ?? "error")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieCollectionViewCell")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension HomeTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = movies?.count {
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath)
        if let cell = cell as? MovieCollectionViewCell {
            cell.updateCell(movie: movies?[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 8) / 4 , height: collectionView.frame.height - 8)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
