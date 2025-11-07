//
//  TransferDetailViewController.swift
//  Blu-Assignment-UIKit
//
//  Created by Amir Hossein on 07/11/2025.
//

import UIKit
import Combine
import BluProjectModel

final class TransferDetailViewController: UIViewController {
    
    private let viewModel: TransferDetailViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let imageView = CircularImageView(frame: .zero)
    private let nameLabel = UILabel()
    private let cardLabel = UILabel()
    private let favoriteButton = UIButton(type: .system)
    
    init(transfer: Transfer, isFavorite: Bool) {
        self.viewModel = TransferDetailViewModel(transfer: transfer, isFavorite: isFavorite)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Transfer Details"
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        cardLabel.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        nameLabel.textAlignment = .center
        
        cardLabel.font = .systemFont(ofSize: 14)
        cardLabel.textColor = .secondaryLabel
        cardLabel.textAlignment = .center
        
        favoriteButton.setTitle("Add to Favorites", for: .normal)
        favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [imageView, nameLabel, cardLabel, favoriteButton])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 120),
            imageView.heightAnchor.constraint(equalToConstant: 120),
            
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.$fullName
            .sink { [weak self] in self?.nameLabel.text = $0 }
            .store(in: &cancellables)
        
        viewModel.$cardNumber
            .sink { [weak self] in self?.cardLabel.text = $0 }
            .store(in: &cancellables)
        
        viewModel.$avatarURL
            .sink { [weak self] in self?.imageView.loadImage(from: $0) }
            .store(in: &cancellables)
        
        viewModel.$isFavorite
            .sink { [weak self] in
                self?.favoriteButton.setTitle($0 ? "Remove Favorite" : "Add to Favorites", for: .normal)
            }
            .store(in: &cancellables)
    }
    
    @objc private func toggleFavorite() {
        Task {
            await viewModel.toggleFavorite()
        }
    }
}
