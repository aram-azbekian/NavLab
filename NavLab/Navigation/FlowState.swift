//
//  FlowState.swift
//  NavLab
//
//  Created by Арам on 19.09.2025.
//

import SwiftUI

enum Tab: Hashable, Codable { case home, catalog, profile }

struct FlowState: Equatable {
    var wasTabPresented: [Tab: Bool] = [.home: false, .catalog: false, .profile: false]
    var selectedTab: Tab = .home
    var sheet: ModalRoute? = nil
    var fullScreen: FullScreenRoute? = nil
}
