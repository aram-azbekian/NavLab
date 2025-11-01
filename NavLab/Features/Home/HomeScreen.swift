//
//  HomeScreen.swift
//  NavLab
//
//  Created by Арам on 19.09.2025.
//

import SwiftUI

enum HomeRoute: Hashable, Codable {
    case product(id: Int)
}

struct HomeHandlers {
    let openProduct: @MainActor (Int) -> Void
    init(openProduct: @escaping (Int) -> Void) {
        self.openProduct = openProduct
    }
}

final class HomeViewModel: ObservableObject {
    fileprivate var handlers: HomeHandlers?
    func setHomeHandlers(handlers: HomeHandlers) {
        self.handlers = handlers
    }
}

struct HomeScreen: View {
    @ObservedObject var homeVM: HomeViewModel

    var body: some View {
        NavigationStack {
            Button("Go to Product #42") {
                homeVM.handlers?.openProduct(42)
            }
            .tint(.green)
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
            .controlSize(.large)
            .navigationTitle("Home")
        }
    }
}
