//
//  FeatureCoordinator.swift
//  NestedUIKitNavigation
//
//  Created by Jason Rich Darmawan Onggo Putra on 08/08/23.
//

import SwiftUI

final class FeatureCoordinator: Coordinator {
    let id: UUID
    
    unowned let navigationController: UINavigationController
    
    init(id: UUID = UUID(), navigationController: UINavigationController) {
        self.id = id
        self.navigationController = navigationController
        print("\(type(of: self)) \(#function) \(id.uuidString)")
    }
    
    deinit { print("\(type(of: self)) \(#function) \(id.uuidString)") }
    
    weak var featureA1ViewController: UIViewController?
    weak var featureA1ViewModel: FeatureA1ViewModel?
    
    weak var featureA2ViewController: UIViewController?
    
    func pushToRoute(_ route: NavigationRoute) -> Bool {
        if let route = route as? FeatureRoute {
            return pushToFeatureRoute(route)
        }
        return false
    }
    
    func canPopToRoute(_ route: NavigationRoute) -> Bool {
        if let route = route as? FeatureRoute {
            return canPopToFeatureRoute(route)
        }
        return false
    }
    
    func popToRoute(_ route: NavigationRoute) -> Bool {
        if let route = route as? FeatureRoute {
            return popToFeatureRoute(route)
        }
        return false
    }
    
    func popToRootViewController(animated: Bool) -> Bool {
        navigationController.popToRootViewController(animated: animated)
        
        return true
    }
    
    private func pushToFeatureRoute(_ route: FeatureRoute) -> Bool {
        switch route {
        case .FeatureA1:
            guard featureA1ViewController == nil else { return false }
            let vm = FeatureA1ViewModel()
            
            let view = FeatureA1View(coordinator: self, vm: vm)
            let featureA1ViewController = HostingController(rootView: view)
            self.featureA1ViewController = featureA1ViewController
            guard let featureA1ViewController = self.featureA1ViewController else { return false }
            navigationController.pushViewController(featureA1ViewController, animated: true)
        case .FeatureA2:
            guard featureA2ViewController == nil else { return false }
            
            let view = FeatureA2View(coordinator: self)
            let featureA2ViewController = HostingController(rootView: view)
            self.featureA2ViewController = featureA2ViewController
            guard let featureA2ViewController = self.featureA2ViewController else { return false }
            navigationController.pushViewController(featureA2ViewController, animated: true)
        }
        
        return true
    }
    
    private func canPopToFeatureRoute(_ route: FeatureRoute) -> Bool {
        switch route {
        case .FeatureA1:
            if featureA1ViewController == nil { return false }
        case .FeatureA2:
            if featureA2ViewController == nil { return false }
        }
        return true
    }
    
    private func popToFeatureRoute(_ route: FeatureRoute) -> Bool {
        switch route {
        case .FeatureA1:
            guard let featureA1ViewController else { return false }
            navigationController.popToViewController(featureA1ViewController, animated: true)
        case .FeatureA2:
            guard let featureA2ViewController else { return false }
            navigationController.popToViewController(featureA2ViewController, animated: true)
        }
        
        return true
    }
    
    
}
