//
//  NavigationController.swift
//  NestedUIKitNavigation
//
//  Created by Jason Rich Darmawan Onggo Putra on 08/08/23.
//

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
