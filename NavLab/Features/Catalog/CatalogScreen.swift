//
//  CatalogScreen.swift
//  NavLab
//
//  Created by Арам on 19.09.2025.
//

import SwiftUI

struct CatalogScreen: View {
    @EnvironmentObject var coordinator: FlowCoordinator

    var body: some View {
        List(0..<50, id: \.self) { id in
            NavigationLink(value: Route.product(id: id)) {
                Text("Product #\(id)")
            }
        }
        .navigationTitle("Catalog")
        .navigationBarTitleDisplayMode(.inline)
    }
}
