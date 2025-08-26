//
//  SideMenu.swift
//  CryptoPrices
//
//  Created by Nilusha Niwanthaka Wimalasena on 23/8/25.
//

import SwiftUI

struct SideMenu: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @Binding var showMenu: Bool
    
    private let logger = DebugLogger.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                Image(systemName: "gearshape")
                Text(NSLocalizedString("menu.settings", comment: "Settings menu item"))
            }
            .font(.headline)
            .onTapGesture {
                withAnimation { showMenu = false }
                logger.log("Navigating to Settings")
                coordinator.push(.Settings)
            }
#if DEBUG
            HStack {
                Image(systemName: "ladybug")
                Text(NSLocalizedString("menu.debugLogs", comment: "Debug Logs menu item"))
            }
            .font(.headline)
            .onTapGesture {
                withAnimation { showMenu = false }
                logger.log("Navigating to Debug Logs")
                coordinator.push(.Debugger)
            }
#endif
            
            Spacer()
        }
        .padding(.top, 40)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(maxHeight: .infinity)
        .background(Color(.systemGray6))
        .ignoresSafeArea(edges: .bottom)
    }
}

//#Preview {
//    SideMenu()
//}
