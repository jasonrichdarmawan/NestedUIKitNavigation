//
//  FeatureA1ViewModel.swift
//  NestedUIKitNavigation
//
//  Created by Jason Rich Darmawan Onggo Putra on 08/08/23.
//

import Foundation

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
