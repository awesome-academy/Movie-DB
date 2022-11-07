//
//  AppBarUIView.swift
//  MovieDB
//
//  Created by le.n.t.trung on 04/11/2022.
//

import UIKit

final class AppBarUIView: UIView {

    @IBOutlet private var contentAppBarUIView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        Bundle.main.loadNibNamed("AppBarUIView", owner: self, options: nil)
        self.addSubview(contentAppBarUIView)
        contentAppBarUIView.frame = self.bounds
        contentAppBarUIView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
