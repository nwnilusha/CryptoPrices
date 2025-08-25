//
//  NoNetworkView.swift
//  CryptoPrices
//
//  Created by Nilusha Niwanthaka Wimalasena on 25/8/25.
//

import SwiftUI

struct NoNetworkView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "wifi.slash")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.gray.opacity(0.6))

            Text(NSLocalizedString("network.offline.title", comment: "Offline title"))
                .font(.headline)
                .foregroundColor(.gray)

            Text(NSLocalizedString("network.offline.message", comment: "Offline message"))
                .font(.subheadline)
                .foregroundColor(.gray.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}



#Preview {
    NoNetworkView()
}
