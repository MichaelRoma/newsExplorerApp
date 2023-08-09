//
//  Extension+UIViewController.swift
//  newsExplorerApp
//
//  Created by Mikhayl Romanovsky on 2023/8/9.
//

import UIKit
internal var activeViewMain: UIView?
extension UIViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func startWaitingIndicator() {
        activeViewMain = UIView()
        guard let activeView = activeViewMain else { return }
        activeView.backgroundColor = .lightGray
        activeView.translatesAutoresizingMaskIntoConstraints = false
        let activeIndicator = UIActivityIndicatorView()
        activeIndicator.translatesAutoresizingMaskIntoConstraints = false
        activeIndicator.startAnimating()
        activeView.addSubview(activeIndicator)
        NSLayoutConstraint.activate([
            activeIndicator.topAnchor.constraint(equalTo: activeView.topAnchor),
            activeIndicator.leadingAnchor.constraint(equalTo: activeView.leadingAnchor),
            activeIndicator.bottomAnchor.constraint(equalTo: activeView.bottomAnchor),
            activeIndicator.trailingAnchor.constraint(equalTo: activeView.trailingAnchor)
        ])
        view.addSubview(activeView)
        activeViewMain = activeView
        NSLayoutConstraint.activate([
            activeView.topAnchor.constraint(equalTo: view.topAnchor),
            activeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            activeView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            activeView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        
    }
    func stopWaitingIndicatore() {
        activeViewMain?.removeFromSuperview()
        activeViewMain = nil
    }
}
