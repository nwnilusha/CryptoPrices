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
    @State private var showErrorAlert = false
    
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
            headerView
            
            SearchBar(
                text: $viewModel.searchText,
                placeholder: NSLocalizedString("coinlist.search.placeholder", comment: "Search bar placeholder")
            )
            .padding(.horizontal)
            .accessibilityIdentifier("CoinList_SearchBar")
            
            contentView
        }
        .navigationDestination(for: Coin.self) { coin in
            CoinDetailView(coin: coin)
                .accessibilityIdentifier("CoinDetailView_\(coin.id)")
        }
        .task {
            logger.log("CoinListView task: loading initial data")
            await viewModel.loadInitialData()
        }
        .onChange(of: networkMonitor.isConnected) { _, isConnected in
            logger.log("Network status changed: \(isConnected)")
            if isConnected {
                Task { await viewModel.refreshCurrencyData() }
            }
        }
        .onChange(of: viewModel.errorMessage) { _, newValue in
            showErrorAlert = newValue != nil
        }
        .alert(
            NSLocalizedString("coinlist.error", comment: "Error alert title"),
            isPresented: $showErrorAlert
        ) {
            Button(NSLocalizedString("coinlist.ok", comment: "OK button"), role: .cancel) {
                logger.log("Error alert dismissed")
                viewModel.errorMessage = nil
            }
            .accessibilityIdentifier("CoinList_ErrorAlert_OKButton")
        } message: {
            Text(viewModel.errorMessage ?? NSLocalizedString("coinlist.unknownError", comment: "Unknown error message"))
                .accessibilityIdentifier("CoinList_ErrorAlert_Message")
        }
    }
    
    private var headerView: some View {
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
                .accessibilityIdentifier("CoinList_MenuButton")
                
                Spacer()
            }
            
            Text(NSLocalizedString("coinlist.title", comment: "Cryptocurrency Prices title"))
                .font(.title2).bold()
                .accessibilityIdentifier("CoinList_Title")
        }
        .frame(height: 56)
        .padding(.horizontal)
    }
    
    private var contentView: some View {
        ZStack(alignment: .leading) {
            if showMenu {
                Color.black.opacity(0.25)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation { showMenu = false }
                        logger.log("Menu dismissed by tap gesture")
                    }
            }
            
            if showMenu {
                SideMenu(showMenu: $showMenu)
                    .frame(width: 220)
                    .transition(.move(edge: .leading))
                    .accessibilityIdentifier("CoinList_SideMenu")
            }
            
            if !networkMonitor.isConnected && viewModel.coins.isEmpty {
                NoNetworkView()
                    .offset(x: showMenu ? 220 : 0)
                    .accessibilityIdentifier("CoinList_NoNetworkView")
            } else {
                coinList
                    .offset(x: showMenu ? 220 : 0)
                    .disabled(showMenu)
                    .animation(.easeInOut, value: showMenu)
                    .accessibilityIdentifier("CoinList_List")
            }
        }
    }
    
    private var coinList: some View {
        List(viewModel.filteredCoins) { coin in
            NavigationLink(value: coin) {
                CoinRow(coin: coin)
                    .accessibilityIdentifier("CoinList_Row_\(coin.id)")
            }
            .onAppear {
                if coin == viewModel.coins.last,
                   !viewModel.isSearching,
                   networkMonitor.isConnected {
                    logger.log("Reached end of list, fetching more data...")
                    Task { await viewModel.fetchCryptoCurrencyData() }
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
    }
}

#Preview {
    let viewModel = CoinListViewModel(service: MockService())
    let networkMonitor = NetworkMonitor()
    let coordinator = AppCoordinator()
    
    CoinListView(viewModel: viewModel)
        .environmentObject(networkMonitor)
        .environmentObject(coordinator)
}
