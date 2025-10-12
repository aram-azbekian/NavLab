//
//  ModalRoute.swift
//  NavLab
//
//  Created by Арам on 05.10.2025.
//

import SwiftUI

enum ModalRoute: Hashable, Codable, Identifiable {
    case settings
    case buy(productID: Int)

    var id: String {
        switch self {
        case .settings:
            return "settings"
        case .buy:
            return "buy"
        }
    }
}
