//
//  CustomImageView.swift
//  MovieDB
//
//  Created by le.n.t.trung on 11/11/2022.
//

import Foundation
import UIKit

final class CustomImageView: UIImageView {
    var imageUrlString: String?
    
    func setImage(url: String) {
        imageUrlString = url
        image = nil
        APICaller.shared.getImage(imageURL: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    if self.imageUrlString == url {
                        self.image = UIImage(data: data)
                    }
                }
            case .failure(let error):
                print(error)
                return
            }
        }
    }

}
