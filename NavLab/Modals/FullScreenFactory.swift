//
//  FullScreenFactory.swift
//  NavLab
//
//  Created by Арам on 12.10.2025.
//

import SwiftUI

enum FullScreenFactory {
    @ViewBuilder
    static func view(for route: FullScreenRoute) -> some View {
        switch route {
        case .login: LoginView()
        }
    }
}
