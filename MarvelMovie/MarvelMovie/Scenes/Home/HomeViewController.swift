import UIKit

class HomeViewController: UIViewController, AlertViewController {

    // MARK: OUTLET
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: VARIABLES
    var genres: [Genre]?
    private let userRepository: UserRepository = UserRepositoryImpl(api: APIService.share)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        userRepository.getGenres { (result) in
            switch result {
            case .success(let genreRespone):
                self.genres = genreRespone?.genres
                self.tableView.reloadData()
            case .failure(let error):
                   self.showErrorAlert(message: error?.errorMessage)
            }
        }
    }
}

extension HomeViewController:  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath)
        if let cell = cell as? HomeTableViewCell {
            cell.updateCell(genre: genres?[indexPath.row], list_id_movies: (genres?[indexPath.row].id))
            return cell
        }
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = genres?.count {
            return count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}
