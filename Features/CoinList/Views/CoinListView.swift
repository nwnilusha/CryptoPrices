//
//  CoinListView.swift
//  CryptoPrices
//
//  Created by Nilusha Niwanthaka Wimalasena on 23/8/25.
//

import SwiftUI

struct CoinListView: View {
    @StateObject private var viewModel: CoinListViewModel
    @State private var showMenu = false
    
    @EnvironmentObject private var coordinator: AppCoordinator
    @Environment(\.dismiss) private var dismiss
    
    init(viewModel: CoinListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                HStack {
                    Button {
                        withAnimation(.easeInOut) {
                            showMenu.toggle()
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .imageScale(.large)
                            .padding(.horizontal, 8)
                            .accessibilityLabel("Menu")
                    }
                    Spacer()
                }

                Text("Cryptocurrency Prices")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .frame(height: 56)
            .padding(.horizontal)

            SearchBar(
                text: $viewModel.searchText,
                placeholder: "Search by name or symbol"
            )
            .padding(.horizontal)

            ZStack(alignment: .leading) {
                if showMenu {
                    Color.black.opacity(0.25)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation { showMenu = false }
                        }
                }

                if showMenu {
                    SideMenu(showMenu: $showMenu)
                        .frame(width: 220)
                        .transition(.move(edge: .leading))
                }

                List(viewModel.filteredCoins) { coin in
                    NavigationLink(value: coin) {
                        CoinRow(coin: coin)
                    }
                }
                .listStyle(.plain)
                .refreshable { await viewModel.fetchCryptoCurrencyData() }
                .overlay(alignment: .center) {
                    if viewModel.isLoading {
                        ProgressView().controlSize(.large)
                    } else if let msg = viewModel.errorMessage {
                        ContentStateView(
                            title: "Oops",
                            message: msg,
                            actionTitle: "Retry"
                        ) {
                            Task { await viewModel.fetchCryptoCurrencyData() }
                        }
                        .padding()
                    } else if viewModel.filteredCoins.isEmpty {
                        ContentStateView(
                            title: "No Results",
                            message: "Try a different search."
                        )
                        .padding()
                    }
                }
                .offset(x: showMenu ? 220 : 0)
                .disabled(showMenu)
                .animation(.easeInOut, value: showMenu)
            }
        }
        .navigationDestination(for: Coin.self) { coin in
            CoinDetailView(coin: coin)
        }
        .task { await viewModel.fetchCryptoCurrencyData() }
    }
}

//#Preview {
//    CoinListView(viewModel: CoinListViewModel())
//}
