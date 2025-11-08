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
    @AppStorage("restorePath") private var restorePath: URL?
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
            Button("Read review") { catalogVM.openReview(productID: id, reviewID: 444) }
        }
        .navigationTitle("Product #\(id)")
        .onAppear {
            guard restorePath == nil else {
                restorePath = nil
                return
            }

            restorePath = URLRouter.build(.product(id: id))
        }
        .onDisappear {
            restorePath = nil
            print("product onDisappear")
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)) { _ in
            restorePath = nil
        }
    }
}
