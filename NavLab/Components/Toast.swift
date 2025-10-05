//
//  Toast.swift
//  NavLab
//
//  Created by Арам on 06.10.2025.
//

import SwiftUI

struct Toast<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(.black.opacity(0.8))
            .foregroundColor(.white)
            .cornerRadius(12)
            .shadow(radius: 4)
    }
}

struct ToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let text: String
    let duration: TimeInterval

    func body(content: Content) -> some View {
        ZStack {
            content

            if isPresented {
                VStack {
                    Spacer()
                    Toast {
                        Text(text)
                    }
                    .transition(.move(edge: .bottom))
                    .padding(.bottom, 40)
                }
                .animation(.easeInOut, value: isPresented)
            }
        }
        .onChange(of: isPresented) { newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    isPresented = false
                }
            }
        }
    }
}

extension View {
    func toast(isPresented: Binding<Bool>, text: String, duration: TimeInterval = 2) -> some View {
        self.modifier(ToastModifier(isPresented: isPresented, text: text, duration: duration))
    }
}

