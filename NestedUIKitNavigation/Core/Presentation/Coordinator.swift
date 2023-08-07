//
//  Coordinator.swift
//  NestedUIKitNavigation
//
//  Created by Jason Rich Darmawan Onggo Putra on 08/08/23.
//

import Foundation

protocol Coordinator {
    func pushToRoute(_ route: NavigationRoute) -> Bool
    func canPopToRoute(_ route: NavigationRoute) -> Bool
    func popToRoute(_ route: NavigationRoute) -> Bool
    func popToRootViewController(animated: Bool) -> Bool
}
