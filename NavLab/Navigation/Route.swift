//
//  Route.swift
//  NavLab
//
//  Created by Арам on 19.09.2025.
//

import Foundation

enum Tab: Hashable, Codable { case home, catalog, profile }

enum Route: Hashable, Codable {
    case home
    case product(id: Int)
    case review(productID: Int, reviewID: String)
}

extension Route {
    var needsAuthorization: Bool {
        switch self {
        case .home:
            false
        case .product:
            true
        case .review:
            true
        }
    }
}
