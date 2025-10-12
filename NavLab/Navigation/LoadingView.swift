//
//  LoadingView.swift
//  NavLab
//
//  Created by Арам on 21.09.2025.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.3).ignoresSafeArea()
            ProgressView()
        }
    }
}

extension View {
    func loadingOverlay(isPresented: Bool) -> some View {
        ZStack {
            self
            LoadingView()
                .opacity(isPresented ? 1.0 : 0.0)
        }
    }
}
