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
    @State private var showNetworkAlert = false
    
    @EnvironmentObject private var coordinator: AppCoordinator
    @EnvironmentObject private var networkMonitor: NetworkMonitor
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
                
                if networkMonitor.isConnected {
                    List(viewModel.filteredCoins) { coin in
                        NavigationLink(value: coin) {
                            CoinRow(coin: coin)
                        }
                        .onAppear {
                            if coin == viewModel.coins.last && viewModel.isSearching == false {
                                Task {
                                    await viewModel.fetchCryptoCurrencyData()
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                    .refreshable {
                        if networkMonitor.isConnected {
                            await viewModel.refreshCurrencyData()
                        } else {
                            showNetworkAlert = true
                        }
                    }
                    .offset(x: showMenu ? 220 : 0)
                    .disabled(showMenu)
                    .animation(.easeInOut, value: showMenu)
                    .onChange(of: networkMonitor.isConnected) { oldValue, newValue in
                        if newValue {
                            Task {
                                await viewModel.loadInitialData()
                            }
                        }
                    }
                } else {
                    NoNetworkView()
                                            .offset(x: showMenu ? 220 : 0)
                }
            }
        }
        .navigationDestination(for: Coin.self) { coin in
            CoinDetailView(coin: coin)
        }
        .task { await viewModel.loadInitialData() }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK", role: .cancel) {
                dismiss()
            }
        } message: {
            Text(viewModel.errorMessage ?? "Unknown error")
        }
    }
}

//#Preview {
//    CoinListView(viewModel: CoinListViewModel())
//}
