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

    init(
        authManager: AuthManager = .init(),
    ) {
        self.authManager = authManager
        homeVM = HomeViewModel()
        catalogVM = CatalogViewModel()
        profileVM = ProfileViewModel()

        homeVM.setHomeHandlers(handlers: HomeHandlers(
            openProduct: { [weak self] productId in
                self?.catalogVM.openProduct(productID: productId)
            }
        ))

        profileVM.setProfileHandlers(handlers: ProfileHandlers(
            openSettingsSheet: { [weak self] in
                self?.presentSheet(.settings)
            }
        ))

        catalogVM.setCatalogHandlers(handlers: CatalogHandlers(
            checkAuthorization: { [weak self] in
                self?.authManager.isAuthorized ?? false
            },
            goLogin: { [weak self] in
                guard let self else { return }
                guard !isDebounced() else { return }
                presentFullScreen(.login)
            },
            switchTabToCatalog: { [weak self] completion in
                guard let self else { return }
                guard !isDebounced() else { return }
                switchTab(.catalog)
                Task { @MainActor in
                    completion()
                }
            },
            buyProductAction: { [weak self] productID in
                guard let self else { return }
                guard !isDebounced() else { return }
                presentSheet(.buy(productID: productID))
            }
        ))
    }

    let homeVM: HomeViewModel
    let catalogVM: CatalogViewModel
    let profileVM: ProfileViewModel

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
            presentToast(text: "Successfully bought product #\(productID)")
        }
    }

    func handleAuthResult(_ success: Bool) {
        isLoading = false
        dismissFullScreen()
        if success {
            catalogVM.openPendingPath()
        }
    }

    func presentToast(text: String) {
        toastText = text
        isToastPresented = true
    }

    // MARK: - Deeplinking
    func handle(url: URL) {
        guard !isDebounced() else { return }
        guard let route = URLRouter.parse(url) else { return }

        switch route {
        case .product(let id):
            catalogVM.openProduct(productID: id)
        case .review(let productID, let reviewID):
            catalogVM.openReview(productID: productID, reviewID: reviewID)
        }
    }

    // MARK: - Helpers
    private func isDebounced() -> Bool {
        let now = Date()
        defer { lastCommandAt = now }
        return now.timeIntervalSince(lastCommandAt) < debounce
    }
}
