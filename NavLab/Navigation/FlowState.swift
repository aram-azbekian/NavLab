//
//  FlowState.swift
//  NavLab
//
//  Created by Арам on 19.09.2025.
//

import SwiftUI

struct FlowState: Equatable {
    var pathPerTab: [Tab: [Route]] = [.home: [], .catalog: [], .profile: []]
    var wasTabPresented: [Tab: Bool] = [.home: false, .catalog: false, .profile: false]
    var selectedTab: Tab = .home
    var sheet: ModalRoute? = nil
    var fullScreen: FullScreenRoute? = nil
    var pendingRoute: PendingNavigation?
}

extension FlowState {
    var currentPath: [Route] {
        get { pathPerTab[selectedTab, default: []] }
        set { pathPerTab[selectedTab] = newValue }
    }
}
