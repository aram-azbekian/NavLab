//
//  FullScreenRoute.swift
//  NavLab
//
//  Created by Арам on 12.10.2025.
//

import Foundation

enum FullScreenRoute: Hashable, Codable, Identifiable {
    case login

    var id: String {
        switch self {
        case .login:
            return "login"
        }
    }
}
