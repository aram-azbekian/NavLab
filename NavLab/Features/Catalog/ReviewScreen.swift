//
//  ReviewScreen.swift
//  NavLab
//
//  Created by Арам on 19.09.2025.
//

import SwiftUI

struct ReviewScreen: View {
    let productID: Int
    let reviewID: Int

    var body: some View {
        VStack(spacing: 16) {
            Text("Review #\(reviewID) for product #\(productID)")
        }
        .padding()
        .navigationTitle("Review \(reviewID)")
        .navigationBarTitleDisplayMode(.inline)
    }
}
