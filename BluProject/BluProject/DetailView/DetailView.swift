//
//  DetailView.swift
//  BluProject
//
//  Created by Amir Hossein on 01/11/2025.
//

import SwiftUI

struct DetailView: View {
    @ObservedObject var viewModel: DetailViewModel
    var body: some View {
        List {
            VStack(alignment: .center, spacing: 50) {
                HStack {
                    Spacer()
                    AsyncImageView(url: URL(string: viewModel.transfer.person.avatar ?? ""))
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color.white, lineWidth: 2)
                        )
                        .shadow(radius: 4)
                    Spacer()
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 20) {
                        Label {
                            Text(viewModel.transfer.person.fullName)
                        } icon: {
                            Image(systemName: "person")
                        }
                        
                        if let email = viewModel.transfer.person.email {
                            Label {
                                Text(email)
                            } icon: {
                                Image(systemName: "mail")
                            }
                        }
                        Label {
                            Text(viewModel.transfer.card.cardNumber)
                        } icon: {
                            Image(systemName: "creditcard")
                        }
                        
                        Label {
                            Text(viewModel.amount)
                        } icon: {
                            Image(systemName: "dollarsign.circle")
                        }
                        
                        Label {
                            Text(viewModel.lastTransferDate)
                        } icon: {
                            Image(systemName: "calendar")
                        }
                    }
                    Spacer()
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.onTapFavoriteButton()
                }) {
                    Image(systemName: viewModel.isFavorite ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                }
            }
        }
        .alert(isPresented: $viewModel.isErrorAlertPresented) {
            Alert(title: Text("Something went wrong"), message: Text(""), dismissButton: .default(Text("OK")))
        }
    }
}
