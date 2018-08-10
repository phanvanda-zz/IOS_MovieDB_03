//  CreditCollectionViewCell.swift
//  Movie
//
//  Created by Da on 8/3/18.
//  Copyright © 2018 Tran Cuong. All rights reserved.
//

import UIKit
import Reusable
import ObjectMapper

class CreditCollectionViewCell: UICollectionViewCell, NibReusable {
    //MARK: OUTLET
    @IBOutlet private weak var profilePathImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    //MARK: VARIABELS
    var credit: Credit?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateCell(credit: Credit?) {
        guard let path = credit?.profilePath,
            let url = URL(string: URLs.posterImage + path),
            let name = credit?.name else {
                return
        }
        self.credit = credit
        profilePathImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "not_found"), options: .allowInvalidSSLCertificates, completed: nil)
        nameLabel.text = name
    }
}
