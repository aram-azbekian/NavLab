//
//  ProductScreen.swift
//  NavLab
//
//  Created by Арам on 19.09.2025.
//

import SwiftUI

struct ProductScreen: View {
    let id: Int
    @EnvironmentObject var coordinator: FlowCoordinator
    
    var body: some View {
        List {
            Text("Product details for #\(id)")
            Button("See review A") { coordinator.open([.review(productID: id, reviewID: "A")]) }
            Button("See review B (requires login)") { coordinator.open([.review(productID: id, reviewID: "B")]) }
        }
    }
}
