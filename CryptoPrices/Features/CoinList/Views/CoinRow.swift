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
            .accessibilityIdentifier("CoinRow_Image_\(coin.id)")

            VStack(alignment: .leading) {
                Text(coin.name)
                    .font(.subheadline)
                    .bold()
                    .accessibilityIdentifier("CoinRow_Name_\(coin.id)")
                
                Text(coin.symbol.uppercased())
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .accessibilityIdentifier("CoinRow_Symbol_\(coin.id)")
            }
            .accessibilityElement(children: .combine)
            .accessibilityIdentifier("CoinRow_TextContainer_\(coin.id)")
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(coin.currentPrice, format: .currency(code: "EUR"))
                    .font(.subheadline)
                    .bold()
                    .accessibilityIdentifier("CoinRow_CurrentPrice_\(coin.id)")
                
                if let change = coin.priceChangePercentage24h {
                    Text(change as NSNumber, formatter: Self.percentFormatter)
                        .font(.caption)
                        .foregroundStyle(change >= 0 ? .green : .red)
                        .accessibilityLabel(
                            change >= 0
                            ? "Price up \(Self.percentFormatter.string(from: change as NSNumber) ?? "")"
                            : "Price down \(Self.percentFormatter.string(from: abs(change) as NSNumber) ?? "")"
                        )
                        .accessibilityIdentifier("CoinRow_PriceChange_\(coin.id)")
                }
            }
            .accessibilityElement(children: .combine)
            .accessibilityIdentifier("CoinRow_PriceContainer_\(coin.id)")
        }
        .padding(.vertical, 6)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(coin.name), price \(coin.currentPrice, format: .currency(code: "EUR"))")
        .accessibilityIdentifier("CoinRow_Container_\(coin.id)")
        .accessibilityAddTraits(.isButton)
    }

    static let percentFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .percent
        nf.maximumFractionDigits = 2
        nf.multiplier = 1
        return nf
    }()
}

#Preview {
    CoinRow(coin: Coin.mockCoin)
}
