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

    func open(_ route: [Route], asRoot: Bool = false) {
        guard !isDebounced() else { return }
        setRouteToTab(route: route, asRoot: asRoot)
    }

    func open(_ route: [Route], in tab: Tab, asRoot: Bool = false) {
        guard !isDebounced() else { return }
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

    // MARK: - Modals API
    func presentSheet(_ route: ModalRoute) {
        guard state.sheet == nil else { return }
        state.sheet = route
    }
    func dismissSheet() { state.sheet = nil }

    func handleBuyResult(_ success: Bool, productID: Int) {
        dismissSheet()
        if success {
            // например, пуш на «Заказ оформлен» или баннер/тост
            presentToast(text: "Successfully bought product #\(productID)")
        }
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
            open([.product(id: id)], in: .catalog, asRoot: true)
        case .review(let productID, let reviewID):
            open([.product(id: productID), .review(productID: productID, reviewID: reviewID)], in: .catalog, asRoot: true)
        default:
            open([route], asRoot: true)
        }
    }

    // MARK: - Helpers
    private func isDebounced() -> Bool {
        let now = Date()
        defer { lastCommandAt = now }
        return now.timeIntervalSince(lastCommandAt) < debounce
    }

    private func setRouteToTab(route: [Route], asRoot: Bool = false) {
        if asRoot {
            state.currentPath = route
        } else {
            state.currentPath.append(contentsOf: route)
        }
    }
}
