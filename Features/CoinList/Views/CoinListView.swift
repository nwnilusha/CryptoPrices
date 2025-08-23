//
//  CoinListView.swift
//  CryptoPrices
//
//  Created by Nilusha Niwanthaka Wimalasena on 23/8/25.
//

import SwiftUI

struct CoinListView: View {
    @StateObject private var viewModel: CoinListViewModel
    
    @EnvironmentObject private var coordinator: AppCoordinator
    @Environment(\.dismiss) private var dismiss
    
    init(viewModel: CoinListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        VStack(spacing: 15) {
            Text("Cryptocurrency Prices")
                .font(.headline)
                .fontWeight(.bold)
            
            List(viewModel.filteredCoins ?? [], id: \.self) { coin in
                NavigationLink(destination: CoinDetailView(coin: coin)) {
                    CoinRow(coin: coin)
                    }
            }
            .listStyle(.plain)
        }
        .task {
            await viewModel.fetchCryptoCurrencyData()
        }
    }
}

//#Preview {
//    CoinListView(viewModel: CoinListViewModel())
//}
