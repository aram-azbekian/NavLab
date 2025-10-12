//
//  NavLabTests.swift
//  NavLabTests
//
//  Created by Арам on 28.09.2025.
//

import XCTest
@testable import NavLab

final class NavLabTests: XCTestCase {

    func testDeepLinkProduct() {
        let authManager = AuthManager()
        authManager.isAuthorized = true
        let c = FlowCoordinator(authManager: authManager)
        c.handle(url: URL(string: "navlab://product/10")!)
        _ = XCTWaiter.wait(for: [expectation(description: "wait 1 sec")], timeout: 1.0)
        XCTAssertEqual(c.state.selectedTab, .catalog)
        XCTAssertEqual(c.state.pathPerTab[.catalog], [.product(id: 10)])
    }

    func testDeepLinkReview() {
        let authManager = AuthManager()
        authManager.isAuthorized = true
        let c = FlowCoordinator(authManager: authManager)
        c.handle(url: URL(string: "navlab://review/42/abc123")!)
        _ = XCTWaiter.wait(for: [expectation(description: "wait 1 sec")], timeout: 1.0)
        XCTAssertEqual(c.state.selectedTab, .catalog)
        XCTAssertEqual(c.state.pathPerTab[.catalog], [.product(id: 42), .review(productID: 42, reviewID: "abc123")])
    }

}
