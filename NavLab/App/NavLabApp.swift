//
//  NavLabApp.swift
//  NavLab
//
//  Created by Арам on 19.09.2025.
//

import SwiftUI

@main
struct NavLabApp: App {
    @StateObject var coordinator = FlowCoordinator()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(coordinator)
        }
    }
}
