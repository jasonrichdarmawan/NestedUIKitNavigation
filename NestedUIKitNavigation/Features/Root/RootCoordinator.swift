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
    
    func pushToRoute(_ route: NavigationRoute) -> Bool {
        if let route = route as? RootRoute {
            return pushToRootRoute(route)
        }
        return false
    }
    
    func popToRoute(_ route: NavigationRoute) -> Bool {
        if let route = route as? RootRoute {
            return popToRootRoute(route)
        }
        return false
    }
    
    func canPopToRoute(_ route: NavigationRoute) -> Bool {
        return false
    }
    
    func popToRootViewController(animated: Bool) -> Bool {
        navigationController.popToRootViewController(animated: animated)
        return true
    }
    
    private func pushToRootRoute(_ route: RootRoute) -> Bool {
        switch route {
        case .FeatureA1:
            let featureCoordinator = FeatureCoordinator(navigationController: navigationController)
            self.featureCoordinator = featureCoordinator
            guard let featureCoordinator = self.featureCoordinator else { return false }
            return featureCoordinator.pushToRoute(FeatureRoute.FeatureA1)
        case .FeatureA2:
            let featureCoordinator = FeatureCoordinator(navigationController: navigationController)
            self.featureCoordinator = featureCoordinator
            guard let featureCoordinator = self.featureCoordinator else { return false }
            return featureCoordinator.pushToRoute(FeatureRoute.FeatureA2)
        }
    }
    
    private func popToRootRoute(_ route: RootRoute) -> Bool {
        switch route {
        case .FeatureA1:
            return false
        case .FeatureA2:
            return false
        }
    }
}
