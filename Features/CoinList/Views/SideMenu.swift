//
//  SideMenu.swift
//  CryptoPrices
//
//  Created by Nilusha Niwanthaka Wimalasena on 23/8/25.
//

import SwiftUI

struct SideMenu: View {
    @Binding var showMenu: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                Image(systemName: "gearshape")
                Text("Settings")
            }
            .font(.headline)
            .onTapGesture {
                withAnimation { showMenu = false }
                navigate(to: "settings")
            }

            HStack {
                Image(systemName: "ladybug")
                Text("Debug Logs")
            }
            .font(.headline)
            .onTapGesture {
                withAnimation { showMenu = false }
                navigate(to: "logs")
            }

            Spacer()
        }
        .padding(.top, 40)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(maxHeight: .infinity)
        .background(Color(.systemGray6))
        .ignoresSafeArea(edges: .bottom)
    }

    private func navigate(to route: String) {
        NotificationCenter.default.post(
            name: .navigate,
            object: route
        )
    }
}

extension Notification.Name {
    static let navigate = Notification.Name("navigate")
}

//#Preview {
//    SideMenu()
//}
