//
//  TransferTableViewCell.swift
//  Blu-Assignment-UIKit
//
//  Created by Amir Hossein on 06/11/2025.
//

import UIKit

class TransferTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "TransferTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cardNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let asyncImageView = CircularImageView(frame: .zero)
    
    private func setupUI() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(cardNumberLabel)
        contentView.addSubview(asyncImageView)
        
        asyncImageView.translatesAutoresizingMaskIntoConstraints = false
        asyncImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        asyncImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        asyncImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5).isActive = true
        asyncImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        nameLabel.leadingAnchor.constraint(equalTo: asyncImageView.trailingAnchor, constant: 10).isActive = true
        nameLabel.topAnchor.constraint(equalTo: asyncImageView.topAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 5).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        cardNumberLabel.leadingAnchor.constraint(equalTo: asyncImageView.trailingAnchor, constant: 10).isActive = true
        cardNumberLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
        cardNumberLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 5).isActive = true
        cardNumberLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func configure(name: String, cardNumber: String, url: String?) {
        nameLabel.text = name
        cardNumberLabel.text = cardNumber
        asyncImageView.loadImage(from: url)
    }
}
