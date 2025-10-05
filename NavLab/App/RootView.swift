//
//  RootView.swift
//  NavLab
//
//  Created by Арам on 19.09.2025.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var coordinator: FlowCoordinator
    
    var body: some View {
        TabView(selection: Binding(get: { coordinator.state.selectedTab }, set: coordinator.switchTab)) {
            NavigationStack(path: Binding(
                get: { coordinator.state.pathPerTab[.home] ?? [] },
                set: { coordinator.state.pathPerTab[.home] = $0 }
            )) {
                HomeScreen()
                    .navigationDestination(for: Route.self) { ViewFactory.view(for: $0) }
            }
            .tabItem { Label("Home", systemImage: "house") }
            .tag(Tab.home)
            
            NavigationStack(path: Binding(
                get: { coordinator.state.pathPerTab[.catalog] ?? [] },
                set: { coordinator.state.pathPerTab[.catalog] = $0 }
            )) {
                CatalogScreen()
                    .navigationDestination(for: Route.self) { ViewFactory.view(for: $0) }
            }
            .tabItem { Label("Catalog", systemImage: "list.bullet") }
            .tag(Tab.catalog)
            
            NavigationStack(path: Binding(
                get: { coordinator.state.pathPerTab[.profile] ?? [] },
                set: { coordinator.state.pathPerTab[.profile] = $0 }
            )) {
                ProfileScreen()
                    .navigationDestination(for: Route.self) { ViewFactory.view(for: $0) }
            }
            .tabItem { Label("Profile", systemImage: "person") }
            .tag(Tab.profile)
        }
        .sheet(item: Binding(
            get: { coordinator.state.sheet.map(IdentifiableModal.init) },
            set: { _ in coordinator.dismissSheet() }
        ), content: { id in
            SheetFactory.view(for: id.route)
        })
        .toast(isPresented: $coordinator.isToastPresented, text: coordinator.toastText)
        .onOpenURL { coordinator.handle(url: $0) }
    }
}

struct IdentifiableModal: Identifiable { let id = UUID(); let route: ModalRoute }
