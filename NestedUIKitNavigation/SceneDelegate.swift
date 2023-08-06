//
//  SceneDelegate.swift
//  NestedUIKitNavigation
//
//  Created by Jason Rich Darmawan Onggo Putra on 06/08/23.
//

import UIKit
import SwiftUI

final class NavigationController: UINavigationController {
    let id: UUID
    
    init(id: UUID = UUID()) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
        print("\(type(of: self)) \(#function) \(id.uuidString)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = UUID()
        super.init(coder: aDecoder)
    }
    
    deinit { print("\(type(of: self)) \(#function) \(id.uuidString)") }
}

protocol ViewControllable: View {
    func viewWillAppear(_ viewController: UIViewController)
    func viewDidAppear(_ viewController: UIViewController)
}

extension ViewControllable {
    func viewWillAppear(_ viewController: UIViewController) {}
    func viewDidAppear(_ viewController: UIViewController) {}
}

final class HostingController<ContentView>: UIHostingController<ContentView> where ContentView: ViewControllable {
    let id: UUID
    
    init(id: UUID = UUID(), rootView: ContentView) {
        self.id = id
        super.init(rootView: rootView)
        print("\(type(of: self)) \(#function) \(id.uuidString)")
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        self.id = UUID()
        super.init(coder: aDecoder)
    }
    
    deinit { print("\(type(of: self)) \(#function) \(id.uuidString)") }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rootView.viewWillAppear(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rootView.viewDidAppear(self)
    }
}

protocol NavigationRoute {}

protocol Coordinator {
    func pushToRoute(_ route: NavigationRoute) -> Bool
    func canPopToRoute(_ route: NavigationRoute) -> Bool
    func popToRoute(_ route: NavigationRoute) -> Bool
    func popToRootViewController(animated: Bool) -> Bool
}

enum FeatureRoute: NavigationRoute {
    case FeatureA1
    case FeatureA2
}

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

struct FeatureA2View: ViewControllable {
    var coordinator: Coordinator
    
    var body: some View {
        VStack {
            Text("Feature A2")
            if coordinator.canPopToRoute(FeatureRoute.FeatureA1) {
                Button {
                    _ = coordinator.popToRoute(FeatureRoute.FeatureA1)
                } label: {
                    Text("pop to Feature A1")
                }
            }
            Spacer()
        }
    }
    
    func viewWillAppear(_ viewController: UIViewController) {
        viewController.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

final class FeatureA1ViewModel: ObservableObject {
    let id: UUID
    
    @Published var title: String
    
    init(id: UUID = UUID(), title: String = "A1") {
        self.id = id
        self.title = title
        print("\(type(of: self)) \(#function) \(id.uuidString)")
    }
    
    deinit { print("\(type(of: self)) \(#function) \(id.uuidString)") }
}

struct FeatureA1View: ViewControllable {
    var coordinator: Coordinator
    
    @ObservedObject var vm: FeatureA1ViewModel
    
    var body: some View {
        VStack {
            Text("Feature \(vm.title)")
            Button {
                _ = coordinator.pushToRoute(FeatureRoute.FeatureA2)
            } label: {
                Text("Go to Feature A2")
            }
            Spacer()
        }
    }
    
    func viewWillAppear(_ viewController: UIViewController) {
        viewController.navigationController?.setNavigationBarHidden(false, animated: true)
        print("\(type(of: self)) \(#function)")
        vm.title = "A1 (updated)"
    }
}

enum RootRoute: NavigationRoute {
    case FeatureA1
    case FeatureA2
}

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
            var featureCoordinator = self.featureCoordinator
            if featureCoordinator == nil {
                featureCoordinator = FeatureCoordinator(navigationController: navigationController)
            }
            self.featureCoordinator = featureCoordinator
            guard let featureCoordinator else { return false }
            return featureCoordinator.pushToRoute(FeatureRoute.FeatureA1)
        case .FeatureA2:
            var featureCoordinator = self.featureCoordinator
            if featureCoordinator == nil {
                featureCoordinator = FeatureCoordinator(navigationController: navigationController)
            }
            self.featureCoordinator = featureCoordinator
            guard let featureCoordinator else { return false }
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

struct RootView: ViewControllable {
    var coordinator: Coordinator
    
    var body: some View {
        VStack {
            Text("Root")
            Button {
                _ = coordinator.pushToRoute(RootRoute.FeatureA1)
            } label: {
                Text("Go to Feature A1")
            }
            Button {
                _ = coordinator.pushToRoute(RootRoute.FeatureA2)
            } label: {
                Text("Go to Feature A2")
            }
            Spacer()
        }
    }
    
    func viewWillAppear(_ viewController: UIViewController) {
        viewController.navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        navigationController = NavigationController()
        
        guard let navigationController else { return }
        
        let rootCoordinator = RootCoordinator(navigationController: navigationController)
        
        let view = RootView(coordinator: rootCoordinator)
        let viewController = HostingController(rootView: view)
        
        window?.rootViewController = navigationController
        
        navigationController.pushViewController(viewController, animated: false)
        
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

