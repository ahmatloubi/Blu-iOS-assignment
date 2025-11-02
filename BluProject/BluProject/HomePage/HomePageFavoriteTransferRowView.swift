//
//  HomePageFavoriteTransferRowView.swift
//  BluProject
//
//  Created by Amir Hossein on 01/11/2025.
//

import SwiftUI

struct HomePageFavoriteTransferRowView: View {
    let name: String
    let imageURL: String
    let description: String
    
    var body: some View {
        VStack {
            AsyncImageView(url: URL(string: imageURL))
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.white, lineWidth: 2)
                )
                .shadow(radius: 4)
            Text(name)
            Text(description)
                .foregroundColor(Color.secondary)
            
        }
    }
}

#Preview {
    HomePageFavoriteTransferRowView(name: "Amir", imageURL: "", description: "Salam!")
}
