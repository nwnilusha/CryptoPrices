//
//  CoinDetailView.swift
//  CryptoPrices
//
//  Created by Nilusha Niwanthaka Wimalasena on 23/8/25.
//

import SwiftUI

struct CoinDetailView: View {
    let coin: Coin
    private let logger = DebugLogger.shared
    
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
                            Text("\(priceChange, specifier: "%.2f")% \(NSLocalizedString("coin.detail.24hChange", comment: "24h change label"))")
                                .font(.headline)
                                .foregroundColor(priceChange >= 0 ? .green : .red)
                        }
                    }
                }
                .padding(.top)
                
                Divider()
                
                GroupBox(label: Label(NSLocalizedString("coin.detail.section.marketInfo", comment: "Market Info section"), systemImage: "chart.line.uptrend.xyaxis")) {
                    VStack(alignment: .leading, spacing: 8) {
                        DetailRow(title: NSLocalizedString("coin.detail.marketCap", comment: ""), value: coin.marketCap)
                        DetailRow(title: NSLocalizedString("coin.detail.marketCapRank", comment: ""), value: coin.marketCapRank)
                        DetailRow(title: NSLocalizedString("coin.detail.high24h", comment: ""), value: coin.high24h)
                        DetailRow(title: NSLocalizedString("coin.detail.low24h", comment: ""), value: coin.low24h)
                        DetailRow(title: NSLocalizedString("coin.detail.priceChange24h", comment: ""), value: coin.priceChange24h, isChange: true)
                        DetailRow(title: NSLocalizedString("coin.detail.priceChangePercentage24h", comment: ""), value: coin.priceChangePercentage24h, suffix: "%", isChange: true)
                        DetailRow(title: NSLocalizedString("coin.detail.totalVolume", comment: ""), value: coin.totalVolume)
                    }
                    .padding(.vertical, 8)
                }
                
                GroupBox(label: Label(NSLocalizedString("coin.detail.section.supplyInfo", comment: "Supply Info section"), systemImage: "shippingbox")) {
                    VStack(alignment: .leading, spacing: 8) {
                        DetailRow(title: NSLocalizedString("coin.detail.circulatingSupply", comment: ""), value: coin.circulatingSupply)
                        DetailRow(title: NSLocalizedString("coin.detail.totalSupply", comment: ""), value: coin.totalSupply)
                        DetailRow(title: NSLocalizedString("coin.detail.maxSupply", comment: ""), value: coin.maxSupply)
                    }
                    .padding(.vertical, 8)
                }
                
                GroupBox(label: Label(NSLocalizedString("coin.detail.section.allTimeStats", comment: "All Time Stats section"), systemImage: "clock.arrow.circlepath")) {
                    VStack(alignment: .leading, spacing: 8) {
                        DetailRow(title: NSLocalizedString("coin.detail.ath", comment: ""), value: coin.ath)
                        DetailRow(title: NSLocalizedString("coin.detail.athChangePercentage", comment: ""), value: coin.athChangePercentage, suffix: "%", isChange: true)
                        DetailRow(title: NSLocalizedString("coin.detail.athDate", comment: ""), value: coin.athDate)
                        DetailRow(title: NSLocalizedString("coin.detail.atl", comment: ""), value: coin.atl)
                        DetailRow(title: NSLocalizedString("coin.detail.atlChangePercentage", comment: ""), value: coin.atlChangePercentage, suffix: "%", isChange: true)
                        DetailRow(title: NSLocalizedString("coin.detail.atlDate", comment: ""), value: coin.atlDate)
                    }
                    .padding(.vertical, 8)
                }
                
                if let roi = coin.roi {
                    GroupBox(label: Label(NSLocalizedString("coin.detail.section.roi", comment: "ROI section"), systemImage: "percent")) {
                        VStack(alignment: .leading, spacing: 8) {
                            DetailRow(title: NSLocalizedString("coin.detail.roi.times", comment: ""), value: roi.times, isChange: true)
                            DetailRow(title: NSLocalizedString("coin.detail.roi.currency", comment: ""), value: roi.currency)
                            DetailRow(title: NSLocalizedString("coin.detail.roi.percentage", comment: ""), value: roi.percentage, suffix: "%", isChange: true)
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
        .onAppear {
            logger.log("Opened CoinDetailView for \(coin.name) (\(coin.symbol.uppercased()))")
        }
        .onDisappear {
            logger.log("Closed CoinDetailView for \(coin.name)")
        }
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
