import UIKit

class MovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func updateCell(movie: Movie?) {
       
        self.titleLabel.text = movie?.original_title
    }
}
