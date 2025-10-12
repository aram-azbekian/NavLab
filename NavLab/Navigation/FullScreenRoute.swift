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

enum PendingNavigation: Equatable {
    case single(route: Route, tab: Tab, asRoot: Bool)
    case stack(routes: [Route], tab: Tab, asRoot: Bool)
}
