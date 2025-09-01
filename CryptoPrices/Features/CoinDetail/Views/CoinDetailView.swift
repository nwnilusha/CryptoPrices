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
                    .accessibilityIdentifier("CoinDetail_Image_\(coin.id)")
                    
                    Text(coin.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .accessibilityIdentifier("CoinDetail_Name_\(coin.id)")
                    
                    Text(coin.symbol.uppercased())
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .accessibilityIdentifier("CoinDetail_Symbol_\(coin.id)")
                    
                    VStack {
                        Text("$\(coin.currentPrice, specifier: "%.2f")")
                            .font(.system(size: 32, weight: .bold))
                            .accessibilityIdentifier("CoinDetail_CurrentPrice_\(coin.id)")
                        
                        if let priceChange = coin.priceChangePercentage24h {
                            Text("\(priceChange, specifier: "%.2f")% \(NSLocalizedString("coin.detail.24hChange", comment: "24h change label"))")
                                .font(.headline)
                                .foregroundColor(priceChange >= 0 ? .green : .red)
                                .accessibilityIdentifier("CoinDetail_PriceChange24h_\(coin.id)")
                        }
                    }
                }
                .padding(.top)
                
                Divider()
                    .accessibilityIdentifier("CoinDetail_Divider1_\(coin.id)")
                
                GroupBox(label: Label(NSLocalizedString("coin.detail.section.marketInfo", comment: "Market Info section"), systemImage: "chart.line.uptrend.xyaxis")) {
                    VStack(alignment: .leading, spacing: 8) {
                        DetailRow(title: NSLocalizedString("coin.detail.marketCap", comment: ""), value: coin.marketCap)
                            .accessibilityIdentifier("CoinDetail_MarketCap_\(coin.id)")
                        DetailRow(title: NSLocalizedString("coin.detail.marketCapRank", comment: ""), value: coin.marketCapRank)
                            .accessibilityIdentifier("CoinDetail_MarketCapRank_\(coin.id)")
                        DetailRow(title: NSLocalizedString("coin.detail.high24h", comment: ""), value: coin.high24h)
                            .accessibilityIdentifier("CoinDetail_High24h_\(coin.id)")
                        DetailRow(title: NSLocalizedString("coin.detail.low24h", comment: ""), value: coin.low24h)
                            .accessibilityIdentifier("CoinDetail_Low24h_\(coin.id)")
                        DetailRow(title: NSLocalizedString("coin.detail.priceChange24h", comment: ""), value: coin.priceChange24h, isChange: true)
                            .accessibilityIdentifier("CoinDetail_PriceChange24hValue_\(coin.id)")
                        DetailRow(title: NSLocalizedString("coin.detail.priceChangePercentage24h", comment: ""), value: coin.priceChangePercentage24h, suffix: "%", isChange: true)
                            .accessibilityIdentifier("CoinDetail_PriceChangePercentage24h_\(coin.id)")
                        DetailRow(title: NSLocalizedString("coin.detail.totalVolume", comment: ""), value: coin.totalVolume)
                            .accessibilityIdentifier("CoinDetail_TotalVolume_\(coin.id)")
                    }
                    .padding(.vertical, 8)
                }
                .accessibilityIdentifier("CoinDetail_MarketInfoSection_\(coin.id)")
                
                GroupBox(label: Label(NSLocalizedString("coin.detail.section.supplyInfo", comment: "Supply Info section"), systemImage: "shippingbox")) {
                    VStack(alignment: .leading, spacing: 8) {
                        DetailRow(title: NSLocalizedString("coin.detail.circulatingSupply", comment: ""), value: coin.circulatingSupply)
                            .accessibilityIdentifier("CoinDetail_CirculatingSupply_\(coin.id)")
                        DetailRow(title: NSLocalizedString("coin.detail.totalSupply", comment: ""), value: coin.totalSupply)
                            .accessibilityIdentifier("CoinDetail_TotalSupply_\(coin.id)")
                        DetailRow(title: NSLocalizedString("coin.detail.maxSupply", comment: ""), value: coin.maxSupply)
                            .accessibilityIdentifier("CoinDetail_MaxSupply_\(coin.id)")
                    }
                    .padding(.vertical, 8)
                }
                .accessibilityIdentifier("CoinDetail_SupplyInfoSection_\(coin.id)")
                
                GroupBox(label: Label(NSLocalizedString("coin.detail.section.allTimeStats", comment: "All Time Stats section"), systemImage: "clock.arrow.circlepath")) {
                    VStack(alignment: .leading, spacing: 8) {
                        DetailRow(title: NSLocalizedString("coin.detail.ath", comment: ""), value: coin.ath)
                            .accessibilityIdentifier("CoinDetail_ATH_\(coin.id)")
                        DetailRow(title: NSLocalizedString("coin.detail.athChangePercentage", comment: ""), value: coin.athChangePercentage, suffix: "%", isChange: true)
                            .accessibilityIdentifier("CoinDetail_ATHChangePercentage_\(coin.id)")
                        DetailRow(title: NSLocalizedString("coin.detail.athDate", comment: ""), value: coin.athDate)
                            .accessibilityIdentifier("CoinDetail_ATHDate_\(coin.id)")
                        DetailRow(title: NSLocalizedString("coin.detail.atl", comment: ""), value: coin.atl)
                            .accessibilityIdentifier("CoinDetail_ATL_\(coin.id)")
                        DetailRow(title: NSLocalizedString("coin.detail.atlChangePercentage", comment: ""), value: coin.atlChangePercentage, suffix: "%", isChange: true)
                            .accessibilityIdentifier("CoinDetail_ATLChangePercentage_\(coin.id)")
                        DetailRow(title: NSLocalizedString("coin.detail.atlDate", comment: ""), value: coin.atlDate)
                            .accessibilityIdentifier("CoinDetail_ATLDate_\(coin.id)")
                    }
                    .padding(.vertical, 8)
                }
                .accessibilityIdentifier("CoinDetail_AllTimeStatsSection_\(coin.id)")
                
                if let roi = coin.roi {
                    GroupBox(label: Label(NSLocalizedString("coin.detail.section.roi", comment: "ROI section"), systemImage: "percent")) {
                        VStack(alignment: .leading, spacing: 8) {
                            DetailRow(title: NSLocalizedString("coin.detail.roi.times", comment: ""), value: roi.times, isChange: true)
                                .accessibilityIdentifier("CoinDetail_ROITimes_\(coin.id)")
                            DetailRow(title: NSLocalizedString("coin.detail.roi.currency", comment: ""), value: roi.currency)
                                .accessibilityIdentifier("CoinDetail_ROICurrency_\(coin.id)")
                            DetailRow(title: NSLocalizedString("coin.detail.roi.percentage", comment: ""), value: roi.percentage, suffix: "%", isChange: true)
                                .accessibilityIdentifier("CoinDetail_ROIPercentage_\(coin.id)")
                        }
                        .padding(.vertical, 8)
                    }
                    .accessibilityIdentifier("CoinDetail_ROISection_\(coin.id)")
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
        .accessibilityIdentifier("CoinDetailView_\(coin.id)")
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


#Preview {
    CoinDetailView(coin: Coin.mockCoin)
}
