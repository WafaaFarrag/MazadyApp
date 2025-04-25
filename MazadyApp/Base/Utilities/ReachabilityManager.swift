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
            Logger.log("Network reachable")
        }
        reachability.whenUnreachable = { _ in
            Logger.log("Network not reachable")
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            Logger.log("Unable to start network notifier")
        }
    }
}
