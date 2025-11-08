//
//  URLRouter.swift
//  NavLab
//
//  Created by Арам on 28.09.2025.
//

import Foundation

enum URLRouter {
    static func parse(_ url: URL) -> CatalogRoute? {
        guard url.scheme == "navlab" else { return nil }
        let comps = url.pathComponents.filter { $0 != "/" }
        guard let host = url.host() else { return nil }

        switch host {
        case "product":
            if comps.count >= 1, let id = Int(comps[0]) { return .product(id: id) }
        case "review":
            if comps.count >= 2, let pid = Int(comps[0]), let rid = Int(comps[0]) { return .review(productID: pid, reviewID: rid) }
        default: break
        }
        return nil
    }

    static func build(_ route: CatalogRoute) -> URL? {
        var path = ""
        switch route {
        case .product(let id): path = "product/\(id)"
        case .review(let pid, let rid): path = "review/\(pid)/\(rid)"
        }
        return URL(string: "navlab://\(path)")
    }
}
