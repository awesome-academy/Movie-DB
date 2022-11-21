//
//  SearchCollectionViewCell.swift
//  MovieDB
//
//  Created by le.n.t.trung on 11/11/2022.
//

import UIKit

final class SearchCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var categoryTitleLabel: UILabel!
    @IBOutlet private weak var categoryView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
    }
    
    func bindData(genre: String, isSelected: Bool) {
        categoryTitleLabel.text = genre
        categoryView.backgroundColor = isSelected ? .yellow : .clear
        categoryTitleLabel.textColor = isSelected ? .black : .white
    }
    
    private func configView() {
        clipsToBounds = true
        layer.cornerRadius = 15
    }
}
