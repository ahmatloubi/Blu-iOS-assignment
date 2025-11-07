//
//  AsyncImage.swift
//  Blu-Assignment-UIKit
//
//  Created by Amir Hossein on 06/11/2025.
//

import UIKit

private let imageCache = NSCache<NSString, UIImage>()

final class CircularImageView: UIImageView {
    
    private var redactedView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
        clipsToBounds = true
        redactedView?.layer.cornerRadius = bounds.width / 2
    }
    
    private func setupView() {
        contentMode = .scaleAspectFill
        clipsToBounds = true
    }
    
    func loadImage(from urlString: String?) {
        guard let urlString else {
            self.image = UIImage(systemName: "person.circle")
            return
        }
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let cacheKey = urlString
        
        if let cached = imageCache.object(forKey: cacheKey as NSString) {
            self.image = cached
            removeRedacted()
            return
        }
        
        showRedacted()
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                guard let image = UIImage(data: data) else { return }

                imageCache.setObject(image, forKey: cacheKey as NSString)

                await MainActor.run {
                    self.image = image
                    self.removeRedacted()
                }
            } catch {
                print("Failed to load image")
                await MainActor.run {
                    self.removeRedacted()
                }
            }
        }

    }
    
    private func showRedacted() {
        if redactedView != nil { return }
        
        layoutIfNeeded() // ✅ ensures correct bounds before using them
        
        let shimmer = UIView(frame: bounds)
        shimmer.backgroundColor = UIColor.systemGray5
        shimmer.layer.cornerRadius = bounds.width / 2
        shimmer.clipsToBounds = true
        
        let gradient = CAGradientLayer()
        gradient.frame = shimmer.bounds
        gradient.colors = [
            UIColor.systemGray4.cgColor,
            UIColor.systemGray5.cgColor,
            UIColor.systemGray4.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.locations = [0, 0.5, 1]
        
        shimmer.layer.addSublayer(gradient)
        
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0, 0.1, 0.3]
        animation.toValue = [0.7, 0.9, 1]
        animation.duration = 1.2
        animation.repeatCount = .infinity
        
        gradient.add(animation, forKey: "shimmer")
        
        addSubview(shimmer)
        redactedView = shimmer
    }

    
    private func removeRedacted() {
        redactedView?.removeFromSuperview()
        redactedView = nil
    }
}
