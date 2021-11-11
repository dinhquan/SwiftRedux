//
//  SwiftReduxApp.swift
//  SwiftRedux
//
//  Created by Quan on 11/11/2021.
//

import SwiftUI

@main
struct SwiftReduxApp: App {
    init() {
        StoreContainer.shared.initializeStore()
    }
    
    var body: some Scene {
        WindowGroup {
            ArticleListView(viewModel: .init())
        }
    }
}

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        register {
            DefaultArticleService() as ArticleService
        }
    }
}
