//
//  FlowCoordinator.swift
//  NavLab
//
//  Created by Арам on 19.09.2025.
//

import SwiftUI

final class FlowCoordinator: ObservableObject {
    @Published var state = FlowState()
    @Published var isLoading: Bool = false

    @Published var isToastPresented: Bool = false
    var toastText: String = ""

    private var lastCommandAt: Date = .distantPast
    private let debounce: TimeInterval = 0.3

    private let authManager: AuthManager

    init(authManager: AuthManager) {
        self.authManager = authManager
    }

    // MARK: - Public API
    func switchTab(_ tab: Tab) {
        guard state.selectedTab != tab else { return }
        state.selectedTab = tab
    }

    func setTabToPresented(tab: Tab) {
        guard let tabValue = state.wasTabPresented[tab] else { return }
        if !tabValue {
            state.wasTabPresented[tab] = true
        }
    }

    func open(_ route: Route, asRoot: Bool = false) {
        open(route, in: state.selectedTab, asRoot: asRoot)
    }

    func open(_ route: Route, in tab: Tab, asRoot: Bool = false) {
        guard !isDebounced() else { return }

        if route.needsAuthorization && !authManager.isAuthorized {
            state.pendingRoute = .single(route: route, tab: tab, asRoot: asRoot)
            presentFullScreen(.login)
            return
        }

        guard tab != state.selectedTab else {
            setRouteToTab(route: route, asRoot: asRoot)
            return
        }

        switchTab(tab)
        if !(state.wasTabPresented[tab] ?? true) {
            isLoading = true
            Task {
                try? await Task.sleep(for: .milliseconds(30))
                await MainActor.run {
                    self.isLoading = false
                    self.setRouteToTab(route: route, asRoot: asRoot)
                }
            }
        } else {
            setRouteToTab(route: route, asRoot: asRoot)
        }
    }

    func openStack(_ route: [Route], asRoot: Bool = false) {
        openStack(route, in: state.selectedTab, asRoot: asRoot)
    }

    func openStack(_ route: [Route], in tab: Tab, asRoot: Bool = false) {
        guard !isDebounced() else { return }

        if route.contains(where: { $0.needsAuthorization }) && !authManager.isAuthorized {
            state.pendingRoute = .stack(routes: route, tab: tab, asRoot: asRoot)
            presentFullScreen(.login)
            return
        }

        guard tab != state.selectedTab else {
            setStackToTab(route: route, asRoot: asRoot)
            return
        }

        switchTab(tab)
        if !(state.wasTabPresented[tab] ?? true) {
            isLoading = true
            Task {
                try? await Task.sleep(for: .milliseconds(30))
                await MainActor.run {
                    self.isLoading = false
                    self.setStackToTab(route: route, asRoot: asRoot)
                }
            }
        } else {
            setStackToTab(route: route, asRoot: asRoot)
        }
    }

    // MARK: - Modals API
    func presentSheet(_ route: ModalRoute) {
        guard state.sheet == nil else { return }
        state.sheet = route
    }
    func dismissSheet() { state.sheet = nil }

    func presentFullScreen(_ route: FullScreenRoute) {
        guard state.fullScreen == nil else { return }
        state.fullScreen = route
    }
    func dismissFullScreen() { state.fullScreen = nil }

    func handleBuyResult(_ success: Bool, productID: Int) {
        dismissSheet()
        if success {
            // например, пуш на «Заказ оформлен» или баннер/тост
            presentToast(text: "Successfully bought product #\(productID)")
        }
    }

    func handleAuthResult(_ success: Bool) {
        isLoading = false
        dismissFullScreen()
        if success, let pendingRoute = state.pendingRoute {
            switch pendingRoute {
            case .single(let route, let tab, let asRoot):
                open(route, in: tab, asRoot: asRoot)
            case .stack(let routes, let tab, let asRoot):
                openStack(routes, in: tab, asRoot: asRoot)
            }
        }
        state.pendingRoute = nil
    }

    func presentToast(text: String) {
        toastText = text
        isToastPresented = true
    }

    // MARK: - Deeplinking
    func handle(url: URL) {
        guard let route = URLRouter.parse(url) else { return }

        switch route {
        case .product(let id):
            open(.product(id: id), in: .catalog, asRoot: true)
        case .review(let productID, let reviewID):
            openStack([.product(id: productID), .review(productID: productID, reviewID: reviewID)], in: .catalog, asRoot: true)
        default:
            open(route, asRoot: true)
        }
    }

    // MARK: - Helpers
    private func isDebounced() -> Bool {
        let now = Date()
        defer { lastCommandAt = now }
        return now.timeIntervalSince(lastCommandAt) < debounce
    }

    private func setRouteToTab(route: Route, asRoot: Bool = false) {
        if asRoot {
            state.currentPath = [route]
        } else {
            state.currentPath.append(route)
        }
    }

    private func setStackToTab(route: [Route], asRoot: Bool = false) {
        if asRoot {
            state.currentPath = route
        } else {
            state.currentPath.append(contentsOf: route)
        }
    }
}
