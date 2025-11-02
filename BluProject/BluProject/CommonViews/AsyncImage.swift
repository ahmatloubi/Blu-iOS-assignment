//
//  ImageLoader.swift
//  BluProject
//
//  Created by Amir Hossein on 31/10/2025.
//

import SwiftUI

struct AsyncImageView: View {
    @StateObject private var loader: ImageLoader
    
    init(url: URL?) {
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
    }
    
    var body: some View {
        content
            .onAppear { loader.load() }
    }
    
    @ViewBuilder
    private var content: some View {
        if #available(iOS 15.0, *) {
            AsyncImage(url: loader.url) { image in
                image
                    .resizable()
                    .scaledToFit()
                
            } placeholder: {
                Circle()
                    .foregroundColor(.secondary)
                    .redacted(reason: .placeholder)
            }
            
            
        } else {
            Group {
                if let image = loader.image {
                    Image(uiImage: image)
                        .resizable()
                } else {
                    Circle()
                        .redacted(reason: .placeholder)
                }
            }
        }
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    let url: URL?
    private var task: URLSessionDataTask?
    
    init(url: URL?) {
        self.url = url
    }
    
    func load() {
        guard let url = url, image == nil else { return }
        
        task = URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                Task { @MainActor in
                    self.image = image
                }
            }
        }
        task?.resume()
    }
    
    deinit {
        task?.cancel()
    }
}
