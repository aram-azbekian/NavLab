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
            HomeScreen(homeVM: coordinator.homeVM)
                .tabItem { Label("Home", systemImage: "house") }
                .tag(Tab.home)
                .onAppear {
                    coordinator.setTabToPresented(tab: .home)
                }

            CatalogScreen(catalogVM: coordinator.catalogVM)
                .tabItem { Label("Catalog", systemImage: "list.bullet") }
                .tag(Tab.catalog)
                .onAppear {
                    coordinator.setTabToPresented(tab: .catalog)
                }

            ProfileScreen(profileVM: coordinator.profileVM)
                .tabItem { Label("Profile", systemImage: "person") }
                .tag(Tab.profile)
                .onAppear {
                    coordinator.setTabToPresented(tab: .profile)
                }
        }
        .sheet(item: Binding(
            get: { coordinator.state.sheet },
            set: { _ in coordinator.dismissSheet() }
        ), content: { route in
            SheetFactory.view(for: route)
        })
        .fullScreenCover(item: Binding(
            get: { coordinator.state.fullScreen },
            set: { _ in coordinator.dismissFullScreen() }
        ), content: { route in
            FullScreenFactory.view(for: route)
        })
        .toast(isPresented: $coordinator.isToastPresented, text: coordinator.toastText)
        .onOpenURL { coordinator.handle(url: $0) }
    }
}
