//
//  AuthManager.swift
//  NavLab
//
//  Created by Арам on 10.10.2025.
//

import Foundation

final class AuthManager: ObservableObject {
    @Published var isAuthorized: Bool = false

    func login(withSuccess: Bool) async -> Bool {
        try? await Task.sleep(for: .seconds(2))
        await MainActor.run {
            isAuthorized = withSuccess
        }
        return withSuccess
    }
}
