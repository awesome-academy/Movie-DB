//
//  CastCollectionViewCell.swift
//  MovieDB
//
//  Created by le.n.t.trung on 15/11/2022.
//

import UIKit

final class CastCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var nameCastLabel: UILabel!
    @IBOutlet private weak var characterCastLabel: UILabel!
    @IBOutlet private weak var castView: UIView!
    @IBOutlet private weak var castImageView: CustomImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
    }
    
    func bindData(actor: Actor) {
        nameCastLabel.text = actor.name
        characterCastLabel.text = actor.character
        castImageView.setImage(url: actor.profileImageURL ?? "")
    }
    
    private func configView() {
        castView.makeCornerRadius(15)
    }
}
