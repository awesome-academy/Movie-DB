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

    func loadImageUsingUrlString(urlString: String) {
        imageUrlString = urlString
        image = nil

        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            self.image = imageFromCache
            return
        }

        DispatchQueue.background(background: {
            APICaller.shared.getImage(imageURL: urlString) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        guard let imageToCache = UIImage(data: data) else { return }
                        if self.imageUrlString == urlString {
                            self.image = imageToCache
                        }
                        imageCache.setObject(imageToCache, forKey: urlString as NSString)
                    }
                case .failure(let error):
                    print(error)
                    return
                }
            }
        })
    }
}
