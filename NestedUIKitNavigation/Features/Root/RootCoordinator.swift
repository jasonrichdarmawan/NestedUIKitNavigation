//
//  RootCoordinator.swift
//  NestedUIKitNavigation
//
//  Created by Jason Rich Darmawan Onggo Putra on 08/08/23.
//

import SwiftUI

final class RootCoordinator: Coordinator {
    let id: UUID
    
    unowned let navigationController: UINavigationController
    
    init(id: UUID = UUID(), navigationController: UINavigationController) {
        self.id = id
        self.navigationController = navigationController
        print("\(type(of: self)) \(#function) \(id.uuidString)")
    }
    
    deinit { print("\(type(of: self)) \(#function) \(id.uuidString)") }
    
    weak var featureCoordinator: FeatureCoordinator?
    
    func pushViewController(_ route: NavigationRoute) -> Bool {
        if let route = route as? RootRoute {
            return pushToRootRoute(route)
        }
        return false
    }
    
    func popToViewController(_ route: NavigationRoute) -> Bool {
        if let route = route as? RootRoute {
            return popToRootRoute(route)
        }
        return false
    }
    
    func canPopToViewController(_ route: NavigationRoute) -> Bool {
        return false
    }
    
    func popToRootViewController(animated: Bool) -> Bool {
        navigationController.popToRootViewController(animated: animated)
        return true
    }
    
    private func pushToRootRoute(_ route: RootRoute) -> Bool {
        switch route {
        case .Root:
            let view = RootView(coordinator: self)
            let viewController = HostingController(rootView: view)
            navigationController.pushViewController(viewController, animated: true)
            return true
        case .FeatureA1:
            let coordinator = FeatureCoordinator(navigationController: navigationController)
            featureCoordinator = coordinator
            return coordinator.pushViewController(FeatureRoute.FeatureA1)
        case .FeatureA2:
            let coordinator = FeatureCoordinator(navigationController: navigationController)
            featureCoordinator = coordinator
            return coordinator.pushViewController(FeatureRoute.FeatureA2)
        }
    }
    
    private func popToRootRoute(_ route: RootRoute) -> Bool {
        switch route {
        case .Root:
            return false
        case .FeatureA1:
            return false
        case .FeatureA2:
            return false
        }
    }
}
