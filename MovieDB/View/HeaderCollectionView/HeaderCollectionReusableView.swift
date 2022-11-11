//
//  HeaderCollectionReusableView.swift
//  MovieDB
//
//  Created by le.n.t.trung on 09/11/2022.
//

import UIKit

final class HeaderCollectionReusableView: UICollectionReusableView {

    @IBOutlet private weak var viewAllButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
 
    func bindData(title: String) {
        titleLabel.text = title
    }
}
