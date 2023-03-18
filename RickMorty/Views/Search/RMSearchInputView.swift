//
//  RMSearchInputView.swift
//  RickMorty
//
//  Created by Dino Pelic on 4. 3. 2023..
//

import UIKit

protocol RMSearchInputViewDelegate: AnyObject {
    func rmSearchInputView(_ inputView: RMSearchInputView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption)
    func rmSearchInputView(_ inputView: RMSearchInputView, didChangeSearchText text: String)
    func rmSearchInputViewDidTapSearchKeyboard(_ inputView: RMSearchInputView)
}

final class RMSearchInputView: UIView {
    private let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search "
        sb.translatesAutoresizingMaskIntoConstraints = false
        return sb
    }()
    
    private var viewModel: RMSearchInputViewViewModel? {
        didSet {
            guard let viewModel = viewModel, viewModel.hasDynamicOptions else { return }
            let options = viewModel.options
            createOptionSelectionView(options: options)
        }
    }
    private var stackView = UIStackView()
    
    weak var delegate: RMSearchInputViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false

        addSubviews(searchBar)
        addConstraints()
        searchBar.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func createOptionSelectionView(options: [RMSearchInputViewViewModel.DynamicOption]) {
        let stackView = UIStackView()
        self.stackView = stackView
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 6
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 0),
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        stackView.backgroundColor = .systemBlue
        
        for (i, option) in options.enumerated() {
            let button = UIButton()
            button.setAttributedTitle(NSAttributedString(string: option.rawValue, attributes: [
                .font: UIFont.systemFont(ofSize: 18, weight: .medium),
                .foregroundColor: UIColor.label
            ]), for: .normal)
            button.backgroundColor = .secondarySystemFill
            button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
            button.tag = i
            button.layer.cornerRadius = 6
            stackView.addArrangedSubview(button)
        }
    }
    
    @objc func didTapButton(_ sender: UIButton) {
        guard let options = viewModel?.options else { return }
        let selected = options[sender.tag]
        delegate?.rmSearchInputView(self, didSelectOption: selected)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            searchBar.rightAnchor.constraint(equalTo: rightAnchor, constant: 5),
            searchBar.leftAnchor.constraint(equalTo: leftAnchor, constant: -5),
            searchBar.heightAnchor.constraint(equalToConstant: 58)
        ])
    }
    
    public func configure(with viewModel: RMSearchInputViewViewModel) {
        searchBar.placeholder = viewModel.searchPlaceholderText
        self.viewModel = viewModel
    }
    
    public func presentKeyboard() {
        searchBar.becomeFirstResponder()
    }
    
    public func update(option: RMSearchInputViewViewModel.DynamicOption, value: String) {
        guard let options = viewModel?.options, let optionIndex = options.firstIndex(of: option) else { return }
        if let buttons = self.stackView.arrangedSubviews as? [UIButton] {
            for button in buttons {
                if button.tag == optionIndex {
                    button.setAttributedTitle(NSAttributedString(string: value.uppercased(), attributes: [
                        .font: UIFont.systemFont(ofSize: 18, weight: .medium),
                        .foregroundColor: UIColor.link
                    ]), for: .normal)
                    break
                }
            }
        }
    }
}

extension RMSearchInputView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.rmSearchInputView(self, didChangeSearchText: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        delegate?.rmSearchInputViewDidTapSearchKeyboard(self)
    }
}
