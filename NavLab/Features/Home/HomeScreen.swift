//
//  HomeScreen.swift
//  NavLab
//
//  Created by Арам on 19.09.2025.
//

import SwiftUI

struct HomeScreen: View {
    @EnvironmentObject var coordinator: FlowCoordinator
    
    var body: some View {
        List {
            Section("Navigation") {
                Button("Go to Product #42") {
                    coordinator.open([.product(id: 42)], in: .catalog, asRoot: true)
                }
            }
        }
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            coordinator.setTabToPresented(tab: .home)
        }
    }
}
