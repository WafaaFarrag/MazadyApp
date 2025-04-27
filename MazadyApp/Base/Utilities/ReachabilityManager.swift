//
//  ReachabilityManager.swift
//  MazadyApp
//
//  Created by wafaa farrag on 25/04/2025.
//

import Foundation
import Reachability

class ReachabilityManager {
    static let shared = ReachabilityManager()
    private let reachability = try! Reachability()

    var isConnected: Bool {
        return reachability.connection != .unavailable
    }

    func startMonitoring() {
        reachability.whenReachable = { _ in
            Logger.log(" Network reachable")
            // You can hide error messages here if needed
        }
        
        reachability.whenUnreachable = { _ in
            Logger.log(" Network not reachable")
            self.handleNetworkUnavailable()
        }

        do {
            try reachability.startNotifier()
        } catch {
            Logger.log("Unable to start network notifier")
            SwiftMessagesService.show(message: "Unable to monitor network", theme: .error)
        }
    }
    
    private func handleNetworkUnavailable() {
        SwiftMessagesService.show(message: "No Internet Connection", theme: .error)
    }
}
