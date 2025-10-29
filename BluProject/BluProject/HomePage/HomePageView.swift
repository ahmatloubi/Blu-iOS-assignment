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
        VStack {
            if (!viewModel.favoriteContacts.isEmpty) {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(viewModel.favoriteContacts) { contact in
                            Text(contact.person.name)
                                .frame(width: 100, height: 100)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
            }
            if #available(iOS 15.0, *) {
                List(selection: $selectedIndex) {
                    ForEach(viewModel.contacts) { contact in
                        Text(contact.person.name)
                            .frame(width: 100, height: 100)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .refreshable {
                    viewModel.refresh()
                }
            } else {
                RefreshableList {
                    ForEach(viewModel.contacts) { contact in
                        Text(contact.person.name)
                            .frame(width: 100, height: 100)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                } onRefresh: {
                    viewModel.refresh()
                }

                
            }
            
        }
        .padding()
    }
}

#Preview {
    HomePageView()
}
