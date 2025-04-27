//
//  LoadingService.swift
//  MazadyApp
//
//  Created by wafaa farrag on 27/04/2025.
//


import UIKit

class LoadingService {
    
    private static var spinner: UIActivityIndicatorView?

    static func show() {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }

        if spinner == nil {
            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.color = .redPrimary
            activityIndicator.center = window.center
            activityIndicator.startAnimating()
            activityIndicator.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            activityIndicator.frame = window.bounds

            window.addSubview(activityIndicator)
            spinner = activityIndicator
        }
    }

    static func hide() {
        spinner?.stopAnimating()
        spinner?.removeFromSuperview()
        spinner = nil
    }
}
