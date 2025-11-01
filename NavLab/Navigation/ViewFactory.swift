//
//  ViewFactory.swift
//  NavLab
//
//  Created by Арам on 19.09.2025.
//

import SwiftUI

enum ViewFactory {
    @ViewBuilder
    static func view(for route: CatalogRoute) -> some View {
        switch route {
        case .product(let id): ProductScreen(id: id)
        case .review(let pid, let rid): ReviewScreen(productID: pid, reviewID: rid)
        }
    }
}
