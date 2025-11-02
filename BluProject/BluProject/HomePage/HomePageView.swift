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
    
    var body: some View {
        NavigationView {
            stateView
                .onAppear() {
                    viewModel.onAppear()
                }
        }
    }
    
    @ViewBuilder
    var stateView: some View {
        switch viewModel.state {
        case .empty: loadedDataView
        case .error: errorView
        case .loaded, .search: loadedDataView
        case .loading: ProgressView()
        }
    }
    
    var emptyView: some View {
        Text("There is no item to show!")
    }
    
    var loadedDataView: some View {
        VStack(alignment: .leading) {
            if (!viewModel.favoriteTransfers.isEmpty) {
                favoriteView
            }
            Text("All")
                .font(.title)
                .bold()
            if #available(iOS 17.0, *) {
                List(content: {
                    transfersForEachView
                    loadMoreView
                })
                .refreshable {
                    viewModel.refresh()
                }
                .searchable(text: $viewModel.searchText, isPresented: $viewModel.isSearhing)
            } else {
                RefreshableScrollView(onRefresh: {
                    viewModel.refresh()
                }, isRefreshing: $viewModel.isRefreshing, content: {
                    VStack {
                        transfersForEachView
                        loadMoreView
                    }
                })
                
            }
        }
        .listStyle(.inset)
        .padding()
    }
    
    var favoriteView: some View {
        VStack(alignment: .leading) {
            Text("Favorites")
                .font(.title)
                .bold()
            ScrollView(.horizontal) {
                HStack {
                    ForEach(viewModel.favoriteTransfers) { transfer in
                        NavigationLink(destination: DetailView(viewModel: .init(rowViewModel: .init(isFavorite: true, transfer: transfer)))) {
                            HomePageFavoriteTransferRowView(name: transfer.person.fullName, imageURL: transfer.person.avatar ?? "", description: transfer.card.cardType)
                                .foregroundColor(.primary)
                                .padding()
                        }
                        
                    }
                }
            }
        }
    }
    
    var transfersForEachView: some View {
        ForEach(viewModel.rowViewModels) { rowViewModel in
            NavigationLink {
                DetailView(viewModel: .init(rowViewModel: rowViewModel))
            } label: {
                HomeRowView(name: rowViewModel.transfer.person.fullName, imageURL: rowViewModel.transfer.person.avatar ?? "", description: rowViewModel.transfer.card.cardNumber, isFavorite: rowViewModel.isFavorite)
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
                        .foregroundColor(.black)
                        .task {
                            viewModel.loadMore()
                        }
                } else {
                    ProgressView()
                        .foregroundColor(.black)
                        .onAppear {
                            viewModel.loadMore()
                        }
                }
                Spacer()
            }
        }
    }
    
    var errorView: some View {
        VStack {
            Text("Error happened loading data!")
            Button("Retry") {
                viewModel.onAppear()
            }
        }
    }
}

#Preview {
    HomePageView()
}
