//
//  HostingController.swift
//  NestedUIKitNavigation
//
//  Created by Jason Rich Darmawan Onggo Putra on 08/08/23.
//

import SwiftUI

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
