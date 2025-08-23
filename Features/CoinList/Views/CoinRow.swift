//
//  CoinRow.swift
//  CryptoPrices
//
//  Created by Nilusha Niwanthaka Wimalasena on 23/8/25.
//

import SwiftUI

struct CoinRow: View {
    let coin: Coin

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: coin.image)) { phase in
                switch phase {
                case .empty:
                    ZStack { Color.secondary.opacity(0.15); ProgressView() }
                case .success(let img): img.resizable().scaledToFill()
                case .failure: Image(systemName: "bitcoinsign.circle")
                        .resizable().scaledToFit().padding(8)
                @unknown default: EmptyView()
                }
            }
            .frame(width: 44, height: 44)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading) {
                Text(coin.name).font(.subheadline).bold()
                Text(coin.symbol.uppercased()).font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(coin.currentPrice, format: .currency(code: "EUR"))
                    .font(.subheadline).bold()
                if let change = coin.priceChangePercentage24h {
                    Text(change as NSNumber, formatter: Self.percentFormatter)
                        .font(.caption)
                        .foregroundStyle(change >= 0 ? .green : .red)
                }
            }
        }
        .padding(.vertical, 6)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(coin.name), price \(coin.currentPrice, format: .currency(code: "EUR"))")
    }

    static let percentFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .percent
        nf.maximumFractionDigits = 2
        nf.multiplier = 1
        return nf
    }()
}

//#Preview {
//    CoinRow(coin: <#Coin#>)
//}
