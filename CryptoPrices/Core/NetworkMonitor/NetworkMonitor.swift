//
//  NetworkMonitor.swift
//  CryptoPrices
//
//  Created by Nilusha Niwanthaka Wimalasena on 24/8/25.
//

import Foundation
import SwiftUI
import Network

enum BannerType {
    case connected
    case disconnected
}

final class NetworkMonitor: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    private let logger = DebugLogger.shared

    @Published var isConnected: Bool = true
    @Published var showBanner: Bool = false
    @Published var bannerType: BannerType = .connected

    private var hideTask: DispatchWorkItem?

    init() {
        logger.log("NetworkMonitor: Initializing network monitoring")
        startNetworkMonitoring()
    }
    
    func startNetworkMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                guard let self else { return }
                let newStatus = path.status == .satisfied
                if newStatus != self.isConnected {
                    self.logger.log("NetworkMonitor: Connection status changed → \(newStatus ? "Connected" : "Disconnected")")
                    
                    self.isConnected = newStatus
                    self.bannerType = newStatus ? .connected : .disconnected
                    self.showBanner = true
                    
                    self.hideTask?.cancel()
                    let task = DispatchWorkItem {
                        withAnimation {
                            self.showBanner = false
                            self.logger.log("NetworkMonitor: Hiding banner")
                        }
                    }
                    self.hideTask = task
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: task)
                }
            }
        }
        monitor.start(queue: queue)
    }
}
