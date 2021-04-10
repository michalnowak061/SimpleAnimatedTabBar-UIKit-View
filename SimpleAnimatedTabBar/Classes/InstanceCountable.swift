//
//  File.swift
//  SimpleAnimatedTabBar
//
//  Created by Michał Nowak on 09/04/2021.
//

import Foundation

protocol InstanceCountable {
    static var instanceCounter: Int { get }
    
    static func numberOfInstances() -> Int
}

extension InstanceCountable {
    static func numberOfInstances() -> Int {
        Self.instanceCounter
    }
}
