//
//  SheetFactory.swift
//  NavLab
//
//  Created by Арам on 05.10.2025.
//

import SwiftUI

enum SheetFactory {
    @ViewBuilder
    static func view(for route: ModalRoute) -> some View {
        switch route {
        case .settings: SettingsSheet()
        case .buy(let id): BuySheet(productID: id)
        }
    }
}
