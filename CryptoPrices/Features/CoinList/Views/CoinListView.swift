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
    
    private let logger = DebugLogger.shared
    
    init(viewModel: CoinListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        logger.log("CoinListView initialized with ViewModel")
    }
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                HStack {
                    Button {
                        withAnimation(.easeInOut) {
                            showMenu.toggle()
                            logger.log("Menu toggled: \(showMenu)")
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .imageScale(.large)
                            .padding(.horizontal, 8)
                            .accessibilityLabel(NSLocalizedString("network.menu", comment: "Menu accessibility label"))
                    }
                    Spacer()
                }
                
                Text(NSLocalizedString("coinlist.title", comment: "Cryptocurrency Prices title"))
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .frame(height: 56)
            .padding(.horizontal)
            
            SearchBar(
                text: $viewModel.searchText,
                placeholder: NSLocalizedString("coinlist.search.placeholder", comment: "Search bar placeholder")
            )
            .padding(.horizontal)
            
            ZStack(alignment: .leading) {
                if showMenu {
                    Color.black.opacity(0.25)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                showMenu = false
                                logger.log("Menu dismissed by tap gesture")
                            }
                        }
                }
                
                if showMenu {
                    SideMenu(showMenu: $showMenu)
                        .frame(width: 220)
                        .transition(.move(edge: .leading))
                }
                
                if !networkMonitor.isConnected && viewModel.coins.isEmpty {
                    NoNetworkView()
                        .offset(x: showMenu ? 220 : 0)
                } else {
                    List(viewModel.filteredCoins) { coin in
                        NavigationLink(value: coin) {
                            CoinRow(coin: coin)
                        }
                        .onAppear {
                            if coin == viewModel.coins.last &&
                               viewModel.isSearching == false &&
                               networkMonitor.isConnected {
                                logger.log("Reached end of list, fetching more data...")
                                Task {
                                    await viewModel.fetchCryptoCurrencyData()
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                    .refreshable {
                        if networkMonitor.isConnected {
                            logger.log("User pulled to refresh coin list")
                            await viewModel.refreshCurrencyData()
                        } else {
                            logger.log("Refresh attempted while offline")
                            showNetworkAlert = true
                        }
                    }
                    .offset(x: showMenu ? 220 : 0)
                    .disabled(showMenu)
                    .animation(.easeInOut, value: showMenu)
                }
            }
        }
        .navigationDestination(for: Coin.self) { coin in
            CoinDetailView(coin: coin)
        }
        .task {
            logger.log("CoinListView task: loading initial data")
            await viewModel.loadInitialData()
        }
        .onChange(of: networkMonitor.isConnected) { _, newValue in
            logger.log("Network status changed: \(newValue)")
            if newValue {
                Task {
                    await viewModel.refreshCurrencyData()
                }
            }
        }
        .alert(NSLocalizedString("coinlist.error", comment: "Error alert title"), isPresented: .constant(viewModel.errorMessage != nil)) {
            Button(NSLocalizedString("coinlist.ok", comment: "OK button"), role: .cancel) {
                logger.log("Error alert dismissed")
                dismiss()
            }
        } message: {
            Text(viewModel.errorMessage ?? NSLocalizedString("coinlist.unknownError", comment: "Unknown error message"))
        }
    }
}



//#Preview {
//    CoinListView(viewModel: CoinListViewModel())
//}
