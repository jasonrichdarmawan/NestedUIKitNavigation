//
//  FeatureA1View.swift
//  NestedUIKitNavigation
//
//  Created by Jason Rich Darmawan Onggo Putra on 08/08/23.
//

import SwiftUI

struct FeatureA1View: ViewControllable {
    var coordinator: Coordinator
    
    @ObservedObject var vm: FeatureA1ViewModel
    
    var body: some View {
        VStack {
            Text("Feature \(vm.title)")
            Button {
                _ = coordinator.pushViewController(FeatureRoute.FeatureA2)
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
