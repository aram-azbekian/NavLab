//
//  FlowCoordinator.swift
//  NavLab
//
//  Created by Арам on 19.09.2025.
//

import SwiftUI

final class FlowCoordinator: ObservableObject {
    @Published var state = FlowState()

    private var lastCommandAt: Date = .distantPast
    private let debounce: TimeInterval = 0.3

    // MARK: - Public API
    func switchTab(_ tab: Tab) {
        guard state.selectedTab != tab else { return }
        state.selectedTab = tab
    }

    func open(_ route: Route, asRoot: Bool = false) {
        guard !isDebounced() else { return }
        updatePath(route, in: state.selectedTab, asRoot: asRoot)
    }

    func open(_ route: Route, in tab: Tab, asRoot: Bool = false) {
        guard !isDebounced() else { return }
        updatePath(route, in: tab, asRoot: asRoot)
        if state.selectedTab != tab {
            state.selectedTab = tab
        }
    }

    func pop() { _ = state.currentPath.popLast() }
    func popToRoot() { state.currentPath.removeAll() }

    func presentSheet(_ route: Route) {
        guard state.sheet == nil else { return }
        state.sheet = route
    }
    func dismissSheet() { state.sheet = nil }

    func presentFullScreen(_ route: Route) {
        guard state.fullScreen == nil else { return }
        state.fullScreen = route
    }
    func dismissFullScreen() { state.fullScreen = nil }

    // MARK: - Helpers
    private func isDebounced() -> Bool {
        let now = Date()
        defer { lastCommandAt = now }
        return now.timeIntervalSince(lastCommandAt) < debounce
    }

    private func updatePath(_ route: Route, in tab: Tab, asRoot: Bool) {
        if asRoot {
            state.pathPerTab[tab] = [route]
        } else {
            state.pathPerTab[tab, default: []].append(route)
        }
    }
}
