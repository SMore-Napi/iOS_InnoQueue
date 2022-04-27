//
//  Settings.swift
//  iOS_InnoQueue
//
//  Created by Роман Солдатов on 20.04.2022.
//

import Foundation

struct Settings {
    var name: String
    var n1: Bool
    var n2: Bool
    var n3: Bool
    var n4: Bool
    var n5: Bool
    
    init(name: String, n1: Bool, n2: Bool, n3: Bool, n4: Bool, n5: Bool) {
        self.name = name
        self.n1 = n1
        self.n2 = n2
        self.n3 = n3
        self.n4 = n4
        self.n5 = n5
    }
}
