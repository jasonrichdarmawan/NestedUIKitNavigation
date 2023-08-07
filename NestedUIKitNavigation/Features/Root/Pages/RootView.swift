//
//  RootView.swift
//  NestedUIKitNavigation
//
//  Created by Jason Rich Darmawan Onggo Putra on 08/08/23.
//

import SwiftUI

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
