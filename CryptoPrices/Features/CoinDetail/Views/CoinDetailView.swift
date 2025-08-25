//
//  CoinDetailView.swift
//  CryptoPrices
//
//  Created by Nilusha Niwanthaka Wimalasena on 23/8/25.
//

import SwiftUI

struct CoinDetailView: View {
    let coin: Coin
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {

                VStack(spacing: 12) {
                    AsyncImage(url: URL(string: coin.image)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                        case .failure(_):
                            Image(systemName: "bitcoinsign.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.gray)
                        case .empty:
                            ProgressView()
                        @unknown default:
                            EmptyView()
                        }
                    }
                    
                    Text(coin.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(coin.symbol.uppercased())
                        .font(.headline)
                        .foregroundColor(.secondary)
 
                    VStack {
                        Text("$\(coin.currentPrice, specifier: "%.2f")")
                            .font(.system(size: 32, weight: .bold))
                        
                        if let priceChange = coin.priceChangePercentage24h {
                            Text("\(priceChange, specifier: "%.2f")% (24h)")
                                .font(.headline)
                                .foregroundColor(priceChange >= 0 ? .green : .red)
                        }
                    }
                }
                .padding(.top)
                
                Divider()

                GroupBox(label: Label("Market Info", systemImage: "chart.line.uptrend.xyaxis")) {
                    VStack(alignment: .leading, spacing: 8) {
                        DetailRow(title: "Market Cap", value: coin.marketCap)
                        DetailRow(title: "Market Cap Rank", value: coin.marketCapRank)
                        DetailRow(title: "24h High", value: coin.high24h)
                        DetailRow(title: "24h Low", value: coin.low24h)
                        DetailRow(title: "24h Price Change", value: coin.priceChange24h, isChange: true)
                        DetailRow(title: "24h Change %", value: coin.priceChangePercentage24h, suffix: "%", isChange: true)
                        DetailRow(title: "Total Volume", value: coin.totalVolume)
                    }
                    .padding(.vertical, 8)
                }

                GroupBox(label: Label("Supply Info", systemImage: "shippingbox")) {
                    VStack(alignment: .leading, spacing: 8) {
                        DetailRow(title: "Circulating Supply", value: coin.circulatingSupply)
                        DetailRow(title: "Total Supply", value: coin.totalSupply)
                        DetailRow(title: "Max Supply", value: coin.maxSupply)
                    }
                    .padding(.vertical, 8)
                }

                GroupBox(label: Label("All Time Stats", systemImage: "clock.arrow.circlepath")) {
                    VStack(alignment: .leading, spacing: 8) {
                        DetailRow(title: "ATH", value: coin.ath)
                        DetailRow(title: "ATH Change %", value: coin.athChangePercentage, suffix: "%", isChange: true)
                        DetailRow(title: "ATH Date", value: coin.athDate)
                        DetailRow(title: "ATL", value: coin.atl)
                        DetailRow(title: "ATL Change %", value: coin.atlChangePercentage, suffix: "%", isChange: true)
                        DetailRow(title: "ATL Date", value: coin.atlDate)
                    }
                    .padding(.vertical, 8)
                }

                if let roi = coin.roi {
                    GroupBox(label: Label("ROI", systemImage: "percent")) {
                        VStack(alignment: .leading, spacing: 8) {
                            DetailRow(title: "Times", value: roi.times, isChange: true)
                            DetailRow(title: "Currency", value: roi.currency)
                            DetailRow(title: "Percentage", value: roi.percentage, suffix: "%", isChange: true)
                        }
                        .padding(.vertical, 8)
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(coin.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DetailRow: View {
    let title: String
    let value: Any?
    var suffix: String = ""
    var isChange: Bool = false
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            if let value = value {
                if let doubleValue = value as? Double {
                    Text("\(doubleValue.formattedWithAbbreviations())\(suffix)")
                        .bold()
                        .foregroundColor(isChange ? (doubleValue >= 0 ? .green : .red) : .primary)
                } else if let intValue = value as? Int {
                    Text("\(intValue)\(suffix)")
                        .bold()
                } else if let stringValue = value as? String {
                    Text(stringValue)
                        .bold()
                }
            } else {
                Text("-")
                    .foregroundColor(.gray)
            }
        }
        .font(.subheadline)
    }
}

extension Double {
    func formattedWithAbbreviations() -> String {
        let num = abs(Double(self))
        let sign = (self < 0) ? "-" : ""
        
        switch num {
        case 1_000_000_000...:
            return "\(sign)\((num / 1_000_000_000).rounded(toPlaces: 2))B"
        case 1_000_000...:
            return "\(sign)\((num / 1_000_000).rounded(toPlaces: 2))M"
        case 1_000...:
            return "\(sign)\((num / 1_000).rounded(toPlaces: 2))K"
        default:
            return "\(sign)\(self.rounded(toPlaces: 2))"
        }
    }
    
    func rounded(toPlaces places: Int) -> String {
        return String(format: "%.\(places)f", self)
    }
}


//#Preview {
//    CoinDetailView()
//}
