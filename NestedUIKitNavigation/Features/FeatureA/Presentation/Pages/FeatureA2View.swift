//
//  FeatureA2View.swift
//  NestedUIKitNavigation
//
//  Created by Jason Rich Darmawan Onggo Putra on 08/08/23.
//

import SwiftUI

struct FeatureA2View: ViewControllable {
    var coordinator: Coordinator
    
    var body: some View {
        VStack {
            Text("Feature A2")
            if coordinator.canPopToViewController(FeatureRoute.FeatureA1) {
                Button {
                    _ = coordinator.popToViewController(FeatureRoute.FeatureA1)
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
