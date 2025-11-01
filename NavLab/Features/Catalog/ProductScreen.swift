//
//  ProductScreen.swift
//  NavLab
//
//  Created by Арам on 19.09.2025.
//

import SwiftUI

struct ProductScreen: View {
    let id: Int
    @EnvironmentObject private var catalogVM: CatalogViewModel
    @State private var showDelete: Bool = false

    var body: some View {
        List {
            Button("Buy") { catalogVM.handlers?.buyProductAction(id) }
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
