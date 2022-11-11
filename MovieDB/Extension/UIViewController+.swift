//
//  UIViewController+.swift
//  MovieDB
//
//  Created by le.n.t.trung on 10/11/2022.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String, messageError: String) {
        let alert = UIAlertController(title: title,
                                      message: messageError,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
