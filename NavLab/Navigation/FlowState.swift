//
//  FlowState.swift
//  NavLab
//
//  Created by Арам on 19.09.2025.
//

import SwiftUI

struct FlowState: Equatable {
    var pathPerTab: [Tab: [Route]] = [.home: [], .catalog: [], .profile: []]
    var selectedTab: Tab = .home
    var sheet: Route? = nil
    var fullScreen: Route? = nil
}

extension FlowState {
    var currentPath: [Route] {
        get { pathPerTab[selectedTab, default: []] }
        set { pathPerTab[selectedTab] = newValue }
    }
}
