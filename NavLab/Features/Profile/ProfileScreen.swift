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
        Text("Profile")
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                coordinator.setTabToPresented(tab: .profile)
            }
    }
}
