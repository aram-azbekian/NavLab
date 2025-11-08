//
//  CatalogScreen.swift
//  NavLab
//
//  Created by Арам on 19.09.2025.
//

import SwiftUI

enum CatalogRoute: Hashable, Codable {
    case product(id: Int)
    case review(productID: Int, reviewID: Int)
}

struct CatalogHandlers {
    let checkAuthorization: () -> Bool
    let goLogin: () -> Void
    let switchTabToCatalog: (@escaping @MainActor () -> Void) -> Void
    let buyProductAction: @MainActor (Int) -> Void
    init(
        checkAuthorization: @escaping () -> Bool,
        goLogin: @escaping () -> Void,
        switchTabToCatalog: @escaping (@MainActor @escaping () -> Void) -> Void,
        buyProductAction: @escaping @MainActor (Int) -> Void
    ) {
        self.checkAuthorization = checkAuthorization
        self.goLogin = goLogin
        self.switchTabToCatalog = switchTabToCatalog
        self.buyProductAction = buyProductAction
    }
}

extension CatalogRoute {
    var needsAuthorization: Bool {
        switch self {
        case .product:
            true
        case .review:
            false
        }
    }
}

struct CatalogScreen: View {
    @ObservedObject var catalogVM: CatalogViewModel

    var body: some View {
        NavigationStack(path: $catalogVM.state.path) {
            List(0..<50, id: \.self) { id in
                NavigationLink(value: CatalogRoute.product(id: id)) {
                    Text("Product #\(id)")
                }
            }
            .navigationDestination(for: CatalogRoute.self) { ViewFactory.view(for: $0) }
            .navigationTitle("Catalog")
        }
        .environmentObject(catalogVM)
    }
}

final class CatalogViewModel: ObservableObject {
    @Published fileprivate var state = CatalogState()

    func openProduct(productID: Int) {
        open(route: .product(id: productID), asRoot: true)
    }

    func openReview(productID: Int, reviewID: Int) {
        let stack: [CatalogRoute] = [.product(id: productID), .review(productID: productID, reviewID: reviewID)]
        openStack(stack: stack, asRoot: true)
    }

    func openPendingPath() {
        if let pendingPath = state.pendingPath {
            switch pendingPath {
            case .single(let route, let asRoot):
                open(route: route, asRoot: asRoot)
            case .stack(let routes, let asRoot):
                openStack(stack: routes, asRoot: asRoot)
            }
        }
    }

    var handlers: CatalogHandlers?
    func setCatalogHandlers(handlers: CatalogHandlers) {
        self.handlers = handlers
    }

    private func openStack(stack: [CatalogRoute], asRoot: Bool = false) {
        if stack.contains(where: { $0.needsAuthorization }) && !(handlers?.checkAuthorization() ?? true) {
            state.pendingPath = .stack(stack: stack, asRoot: asRoot)
            handlers?.goLogin()
            return
        }

        handlers?.switchTabToCatalog { [weak self] in
            self?.setStack(stack: stack, asRoot: asRoot)
        }
    }

    private func open(route: CatalogRoute, asRoot: Bool = false) {
        if route.needsAuthorization && !(handlers?.checkAuthorization() ?? true) {
            state.pendingPath = .single(route: route, asRoot: asRoot)
            handlers?.goLogin()
            return
        }

        handlers?.switchTabToCatalog { [weak self] in
            self?.setRoute(route: route, asRoot: asRoot)
        }
    }

    private func setRoute(route: CatalogRoute, asRoot: Bool = false) {
        if asRoot {
            state.path = [route]
        } else {
            state.path.append(route)
        }
    }

    private func setStack(stack: [CatalogRoute], asRoot: Bool = false) {
        if asRoot {
            state.path = stack
        } else {
            state.path.append(contentsOf: stack)
        }
    }
}

private struct CatalogState {
    var path: [CatalogRoute] = []
    var pendingPath: PendingPath?
}

private enum PendingPath: Equatable {
    case single(route: CatalogRoute, asRoot: Bool)
    case stack(stack: [CatalogRoute], asRoot: Bool)
}
