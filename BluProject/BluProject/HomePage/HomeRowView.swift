//
//  HomeRowView.swift
//  BluProject
//
//  Created by Amir Hossein on 31/10/2025.
//

import SwiftUI
import BluProjectModel

struct HomeRowView: View {
    let name: String
    let imageURL: String
    let description: String
    
    var body: some View {
        HStack(spacing: 15) {
            AsyncImageView(url: URL(string: imageURL))
                .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color.white, lineWidth: 2)
                    )
                    .shadow(radius: 4)
            VStack(alignment: .leading, spacing: 15) {
                Text(name)
                Text(description)
                    .foregroundColor(Color.secondary)
            }
            .multilineTextAlignment(.leading)
        }
    }
}

#Preview {
    HomeRowView(name: "Amir", imageURL: "", description: "hi")
}

