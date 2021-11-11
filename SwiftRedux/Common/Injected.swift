//
//  Injected.swift
//  SwiftRedux
//
//  Created by Quan on 11/11/2021.
//

import Foundation

@propertyWrapper
struct Injected<T> {
    var wrappedValue: T
    
    init() {
        wrappedValue = Resolver.resolve()
    }
}

final class Resolver {
    private var dependencies: [String: Any] = [:]
    private static var shared = Resolver()

    static func register<T>(_ dependency: T) {
        shared.register(dependency)
    }

    static func resolve<T>() -> T {
        shared.resolve()
    }

    private func register<T>(_ dependency: T) {
        let key = String(describing: T.self)
        dependencies[key] = dependency
    }

    private func resolve<T>() -> T {
        let key = String(describing: T.self)
        let dependency = dependencies[key] as? T
        precondition(dependency != nil, "No dependency found for \(key)! must register a dependency before resolve.")
        return dependency!
    }
}
