//
//  ProfileScreen.swift
//  NavLab
//
//  Created by Арам on 19.09.2025.
//

import SwiftUI

struct ProfileScreen: View {
    @EnvironmentObject private var coordinator: FlowCoordinator

    var body: some View {
        Button("Open Settings") { coordinator.presentSheet(.settings) }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                coordinator.setTabToPresented(tab: .profile)
            }
    }
}
