//
//  NavLabApp.swift
//  NavLab
//
//  Created by Арам on 19.09.2025.
//

import SwiftUI

@main
struct NavLabApp: App {
    @StateObject var coordinator: FlowCoordinator
    @StateObject var authManager: AuthManager

    init() {
        let authManager = AuthManager()
        _authManager = StateObject(wrappedValue: authManager)
        _coordinator = StateObject(wrappedValue: FlowCoordinator(authManager: authManager))
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .loadingOverlay(isPresented: coordinator.isLoading)
            .environmentObject(coordinator)
            .environmentObject(authManager)
        }
    }
}
