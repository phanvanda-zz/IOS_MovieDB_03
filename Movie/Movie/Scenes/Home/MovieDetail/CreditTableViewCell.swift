//
//  CreditTableViewCell.swift
//  Movie
//
//  Created by Da on 8/7/18.
//  Copyright © 2018 Tran Cuong. All rights reserved.
//

import UIKit
import Reusable

protocol pushCreditTableViewDelegate: class {
    func pushCreditDetail(credit: Credit)
}

class CreditTableViewCell: UITableViewCell, NibReusable {
     // MARK: OUTLET
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: VARIABLES
    var credits = [Credit]()
    weak var delegate: pushCreditTableViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    func setContentForCell(data: [Credit], title: String) {
        titleLabel.text = title
        credits = data
        collectionView.reloadData()
    }

    private func setup() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(cellType: CreditCollectionViewCell.self)
    }
}

extension CreditTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return credits.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CreditCollectionViewCell.self)
        let credit = credits[indexPath.row]
        cell.updateCell(credit: credit)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width) / 4, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sizeCollectionView.spaceItem
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CreditCollectionViewCell,
            let credit = cell.credit else {
                return
        }
        delegate?.pushCreditDetail(credit: credit)
    }
}
