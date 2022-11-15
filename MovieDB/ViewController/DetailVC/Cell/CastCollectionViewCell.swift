//
//  CastCollectionViewCell.swift
//  MovieDB
//
//  Created by le.n.t.trung on 15/11/2022.
//

import UIKit

final class CastCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var castImageView: UIImageView!
    @IBOutlet private weak var nameCastLabel: UILabel!
    @IBOutlet private weak var characterCastLabel: UILabel!
    @IBOutlet private weak var castView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
    }
    
    private func configView() {
        castView.makeCornerRadius(15)
    }
}
