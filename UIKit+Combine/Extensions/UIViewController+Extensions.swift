//
//  UIViewController+Extensions.swift
//  UIKit+Combine
//
//  Created by Eren Demir on 2.04.2023.
//

import UIKit

fileprivate var containerView: UIView!

//MARK: - Dialog Components
extension UIViewController {
    func showToast(title:String ,text:String, delay:Int) -> Void {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        self.present(alert, animated: true)
        let deadlineTime = DispatchTime.now() + .seconds(delay)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            alert.dismiss(animated: true, completion: nil)
        })
    }
}

//MARK: - Loading Components
extension UIViewController {
    func showLoadingCircularIndicator() {
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .systemGray
        containerView.alpha = 0
        self.view.addSubview(containerView)
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .white
        containerView.addSubview(activityIndicator)
        UIView.animate(withDuration: 0.5) {
            containerView.alpha = 1
            containerView.layer.masksToBounds = true
            containerView.clipsToBounds = true
            containerView.layer.cornerRadius = 30
        }
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo:view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo:view.centerXAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 150),
            containerView.widthAnchor.constraint(equalToConstant: 150),
            activityIndicator.centerYAnchor.constraint(equalTo:view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo:view.centerXAnchor),
        ])
        activityIndicator.startAnimating()
    }
    
    func closeLoadingCircularIndicator() {
        containerView?.removeFromSuperview()
        containerView = nil
    }
}
