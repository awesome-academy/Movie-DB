//
//  UIViewController+.swift
//  MovieDB
//
//  Created by le.n.t.trung on 10/11/2022.
//

import Foundation
import UIKit

extension UIViewController {
    static let activityIndicator = UIActivityIndicatorView(style: .large)
    
    func showAlert(title: String, messageError: String) {
        let alert = UIAlertController(title: title,
                                      message: messageError,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleIndicator(type: IndicatorType) {
        switch type {
        case .show:
            UIViewController.activityIndicator.startAnimating()
            view.isUserInteractionEnabled = false
        case .hide:
            UIViewController.activityIndicator.stopAnimating()
            view.isUserInteractionEnabled = true
        }
    }
    
    func configActivityIndicator() {
        view.addSubview(UIViewController.activityIndicator)
        UIViewController.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        UIViewController.activityIndicator.hidesWhenStopped = true
        UIViewController.activityIndicator.color = UIColor.white
        let horizontalConstraint = NSLayoutConstraint(item: UIViewController.activityIndicator,
                                                      attribute: .centerX,
                                                      relatedBy: .equal,
                                                      toItem: view,
                                                      attribute: .centerX,
                                                      multiplier: 1,
                                                      constant: 0)
        view.addConstraint(horizontalConstraint)
        let verticalConstraint = NSLayoutConstraint(item: UIViewController.activityIndicator,
                                                    attribute: .centerY,
                                                    relatedBy: .equal,
                                                    toItem: view,
                                                    attribute: .centerY,
                                                    multiplier: 1,
                                                    constant: 0)
        view.addConstraint(verticalConstraint)
    }
}
