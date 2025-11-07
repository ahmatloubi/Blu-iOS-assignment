import UIKit

final class FavoriteTransferCell: UICollectionViewCell {
    static let reuseIdentifier = "FavoriteTransferCell"

    private let asyncImageView = CircularImageView(frame: .zero)
    private let nameLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let stackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 6

        asyncImageView.translatesAutoresizingMaskIntoConstraints = false
        asyncImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        asyncImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true

        nameLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        nameLabel.textColor = .label
        nameLabel.textAlignment = .center
        nameLabel.lineBreakMode = .byTruncatingTail
        
        subtitleLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.lineBreakMode = .byTruncatingTail
        subtitleLabel.textAlignment = .center
        

        stackView.addArrangedSubview(asyncImageView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(subtitleLabel)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 6),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 6),
        ])
    }

    func configure(name: String, imageURL: String?) {
        nameLabel.text = name
        asyncImageView.loadImage(from: imageURL)
    }
}
