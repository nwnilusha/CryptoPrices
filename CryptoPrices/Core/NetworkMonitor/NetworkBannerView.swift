//
//  NetworkBannerView.swift
//  CryptoPrices
//
//  Created by Nilusha Niwanthaka Wimalasena on 24/8/25.
//

import SwiftUI

struct NetworkBannerView: View {
    let bannerType: BannerType

    var body: some View {
        VStack {
            HStack(spacing: 8) {
                Image(systemName: bannerType == .connected ? "wifi" : "wifi.slash")
                Text(bannerType == .connected ? NSLocalizedString("network.banner.connected", comment: "Internet Connection Available") : NSLocalizedString("network.banner.disconnected", comment: "No Internet Connection"))
                    .bold()
            }
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(bannerType == .connected ? Color.green : Color.red)
            .cornerRadius(10)
            .padding(.horizontal)
            .padding(.top, 40)
            .transition(.move(edge: .top).combined(with: .opacity))
            .animation(.easeInOut, value: bannerType)
            
            Spacer()
        }
        .zIndex(1)
    }
}
