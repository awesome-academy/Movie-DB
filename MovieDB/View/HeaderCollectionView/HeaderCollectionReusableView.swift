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
    
    private var category: CategoryPath?
    private var didTapViewAllAction: ((CategoryPath) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func viewAllListFilm(_ callBack: @escaping((CategoryPath) -> Void)) {
        didTapViewAllAction = callBack
    }
 
    func bindData(title: String, isShowViewAll: Bool, category: CategoryPath?) {
        viewAllButton.isHidden = !isShowViewAll
        titleLabel.text = title
        self.category = category
    }
    
    @IBAction func didViewAllTapAction(_ sender: Any) {
        guard let category = self.category else { return }
        didTapViewAllAction?(category)
    }
}
