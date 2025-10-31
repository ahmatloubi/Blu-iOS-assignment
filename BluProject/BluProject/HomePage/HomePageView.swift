//
//  ContentView.swift
//  BluProject
//
//  Created by Amir Hossein on 27/10/2025.
//

import SwiftUI
import Factory

struct HomePageView: View {
    @InjectedObject(\.homePageViewModel) var viewModel
    @State private var selectedIndex: Int?
    
    var body: some View {
        stateView
            .onAppear() {
                viewModel.onAppear()
            }
    }
    
    @ViewBuilder
    var stateView: some View {
        switch viewModel.state {
        case .empty: Text("There is no item to show!")
        case .error: Text("Error happened loading data!")
        case .loaded, .search: loadedDataView
        case .loading: ProgressView()
        }
    }
    
    var loadedDataView: some View {
        VStack {
            if (!viewModel.favoriteTransfers.isEmpty) {
                favoriteView
            }
            if #available(iOS 15.0, *) {
                List(content: {
                    transfersForEachView
                    loadMoreView
                })
                .refreshable {
                    viewModel.refresh()
                }
            } else {
                RefreshableList {
                    VStack {
                        transfersForEachView
                        loadMoreView
                    }
                } onRefresh: {
                    viewModel.refresh()
                }
            }
        }
        .padding()
    }
    
    var favoriteView: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(viewModel.favoriteTransfers) { transfer in
                    Text(transfer.person.fullName)
                        .frame(width: 100, height: 100)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
    }
    
    var transfersForEachView: some View {
        ForEach(viewModel.transfers) { transfer in
            NavigationLink {
                Text(transfer.card.cardNumber)
            } label: {
                HomeRowView(name: transfer.person.fullName, imageURL: transfer.person.avatar ?? "", description: transfer.card.cardNumber)
            }
            
        }
    }
    
    @ViewBuilder
    var loadMoreView: some View {
        if viewModel.canLoadMore {
            HStack {
                Spacer()
                if #available(iOS 15.0, *) {
                    ProgressView()
                        .task {
                            viewModel.loadMore()
                        }
                } else {
                    ProgressView()
                        .onAppear {
                            viewModel.loadMore()
                        }
                }
                Spacer()
            }
        }
    }
}

#Preview {
    HomePageView()
}
