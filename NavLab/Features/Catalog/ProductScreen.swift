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
    @State private var showDelete: Bool = false

    var body: some View {
        List {
            Button("Buy") { coordinator.presentSheet(.buy(productID: id)) }
            Button("Delete from favorites") { showDelete = true }
                .confirmationDialog(
                    "Delete item?",
                    isPresented: $showDelete,
                    titleVisibility: .visible
                ) {
                    Button("Delete", role: .destructive) {
                    }
                    Button("Cancel", role: .cancel) { }
                }
        }
        .navigationTitle("Product #\(id)")
    }
}
