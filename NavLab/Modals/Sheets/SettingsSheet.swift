//
//  SettingsSheet.swift
//  NavLab
//
//  Created by Арам on 06.10.2025.
//

import SwiftUI

struct SettingsSheet: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Privacy Policy", value: "privacy")
                NavigationLink("Terms", value: "terms")
            }
            .navigationTitle("Settings")
            .navigationDestination(for: String.self) { key in
                switch key {
                case "privacy": Text("Privacy policy text…").padding()
                case "terms": Text("Terms text…").padding()
                default: EmptyView()
                }
            }
        }
    }
}

