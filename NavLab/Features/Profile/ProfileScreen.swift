//
//  ProfileScreen.swift
//  NavLab
//
//  Created by Арам on 19.09.2025.
//

import SwiftUI

struct ProfileScreen: View {
    @ObservedObject var profileVM: ProfileViewModel

    var body: some View {
        NavigationStack {
            Button("Open Settings") { profileVM.handlers?.openSettingsSheet() }
                .tint(.green)
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                .controlSize(.large)
                .navigationTitle("Profile")
        }
    }
}

struct ProfileHandlers {
    let openSettingsSheet: @MainActor () -> Void
    init(openSettingsSheet: @escaping () -> Void) {
        self.openSettingsSheet = openSettingsSheet
    }
}

final class ProfileViewModel: ObservableObject {
    fileprivate var handlers: ProfileHandlers?
    func setProfileHandlers(handlers: ProfileHandlers) {
        self.handlers = handlers
    }
}
