//
//  Coordinator.swift
//  NestedUIKitNavigation
//
//  Created by Jason Rich Darmawan Onggo Putra on 08/08/23.
//

import Foundation

protocol Coordinator {
    func pushViewController(_ route: NavigationRoute) -> Bool
    func canPopToViewController(_ route: NavigationRoute) -> Bool
    func popToViewController(_ route: NavigationRoute) -> Bool
    func popToRootViewController(animated: Bool) -> Bool
}
