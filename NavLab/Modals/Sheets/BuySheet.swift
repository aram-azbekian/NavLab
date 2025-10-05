//
//  BuySheet.swift
//  NavLab
//
//  Created by Арам on 06.10.2025.
//

import SwiftUI

struct BuySheet: View {
    @EnvironmentObject var c: FlowCoordinator
    let productID: Int
    @State private var quantity = 1
    @State private var isSubmitting = false
    @State private var error: String?

    var body: some View {
        NavigationStack {
            Form {
                Stepper("Quantity: \(quantity)", value: $quantity, in: 1...10)
                if let error { Text(error).foregroundColor(.red) }
            }
            .navigationTitle("Buy #\(productID)")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { c.dismissSheet() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(isSubmitting ? "…" : "Pay") {
                        Task {
                            isSubmitting = true; defer { isSubmitting = false }
                            // имитация заказа
                            try? await Task.sleep(nanoseconds: 700_000_000)
                            c.handleBuyResult(true, productID: productID)
                        }
                    }.disabled(isSubmitting)
                }
            }
        }
    }
}

