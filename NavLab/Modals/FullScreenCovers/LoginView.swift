//
//  LoginView.swift
//  NavLab
//
//  Created by Арам on 12.10.2025.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var authManager: AuthManager
    @EnvironmentObject private var coordinator: FlowCoordinator

    var body: some View {
        VStack(spacing: 20) {
            Button("Login Successfully") {
                auth(withSuccess: true)
            }
            .padding()
            .border(.black)

            Button("Fail Login") {
                auth(withSuccess: false)
            }
            .padding()
            .border(.black)
        }
        .loadingOverlay(isPresented: coordinator.isLoading)
    }

    func auth(withSuccess: Bool) {
        coordinator.isLoading = true
        Task {
            let res = await authManager.login(withSuccess: withSuccess)
            await MainActor.run {
                coordinator.handleAuthResult(res)
            }
        }
    }
}
