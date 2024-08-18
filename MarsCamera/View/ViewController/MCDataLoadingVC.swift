//
//  MCDataLoadingVC.swift
//  MarsCamera
//
//  Created by Olha Pylypiv on 12.08.2024.


import UIKit

class MCDataLoadingVC: UIViewController {
    
    var containerView: UIView!
    var emptyStateView: MCEmptyStateView?
    
    func showLoadingView() {
        if containerView != nil { return }
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        UIView.animate(withDuration: 0.25) { self.containerView.alpha = 0.8 }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
        
        activityIndicator.startAnimating()
    }
    
    func dismissLoadingView() {
        DispatchQueue.main.async {
            if self.containerView != nil {
                self.containerView.removeFromSuperview()
                self.containerView = nil
            }
        }
    }
    
    func showEmptyStateView(with message: String, in view: UIView) {
        dismissEmptyStateView()
        emptyStateView = MCEmptyStateView(message: message)
        view.addSubview(emptyStateView!)
        
        emptyStateView?.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emptyStateView!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView!.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateView!.widthAnchor.constraint(equalTo: view.widthAnchor),
            emptyStateView!.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
    
    func dismissEmptyStateView() {
        emptyStateView?.removeFromSuperview()
        emptyStateView = nil
    }
    
    func presentErrorOnMainThread(message: String) {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: "Something went wrong", message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .cancel))
            self.present(ac, animated: true)
        }
    }
    
}
