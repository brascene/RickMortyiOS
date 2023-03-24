//
//  RMTableLoadingFooterView.swift
//  RickMorty
//
//  Created by Dino Pelic on 24. 3. 2023..
//

import UIKit

final class RMTableLoadingFooterView: UIView {
    private var spinner: UIActivityIndicatorView = {
        let s = UIActivityIndicatorView()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.hidesWhenStopped = true
        return s
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(spinner)
        spinner.startAnimating()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            spinner.widthAnchor.constraint(equalToConstant: 55),
            spinner.heightAnchor.constraint(equalToConstant: 55),
            
            self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            self.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
}
